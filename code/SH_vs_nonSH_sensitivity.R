# SH_vs_nonSH_sensitivity.R
# -------------------------
# Supplementary analyses for SH_vs_nonSH_analysis.R, on the same
# account-level data (UD_averages_totals.xlsx).
#
#   1. Test-choice diagnostics: shape of the paired differences (SH minus
#      non-SH) per metric -- skew, Shapiro-Wilk, ties at zero, and how far
#      the mean difference is carried by the highest-engagement accounts.
#      These justify the Wilcoxon signed-rank test over a paired t-test.
#   2. Sensitivity: the primary analysis re-run without the 2 accounts with
#      the most followers (AACAP 2026), and without the 2 (and 3)
#      highest-engagement accounts, ranked by overall average views per post
#      (total_tweet_views_avg) among the paired sample. Follower counts come
#      from the profile screenshots (followers_from_screenshots.csv); accounts
#      with no count are left out of the ranking, not the analysis. Selection
#      is by rule, not by hardcoded ID; the IDs dropped are printed to the
#      console only.
#   3. Leave-one-out: the primary analysis re-run 45 times, dropping each
#      account once, to show no single account drives the result.
#   4. Sign test: an assumption-light check. The signed-rank test assumes the
#      differences are roughly symmetric; the sign test only counts how many
#      accounts are higher on SH posts, so it holds even if they are not.
#   5. Pratt zero handling: the signed-rank test re-run with zero differences
#      kept in the ranking (Pratt, 1959) instead of dropped. Matters most for
#      reposts, where about a third of accounts tie at zero. coin applies no
#      continuity correction, which at n = 45 changes p only slightly.
#
# Same paired filter, test call, Holm family and rcompanion effect size as
# SH_vs_nonSH_analysis.R -- keep the two in step if either changes.
#
# Results are printed to the console; no files are written.
#
# Required packages: readxl, dplyr, rcompanion, coin

library(readxl)
library(dplyr)
library(rcompanion)
library(coin)

# ── Inputs ────────────────────────────────────────────────────────────────────
# Code shown for transparency. The account-level data and follower counts are
# not public (IRB data-protection plan), so this script will not run as-is.
INPUT_FILE     <- "UD_averages_totals.xlsx"
FOLLOWERS_FILE <- "followers_from_screenshots.csv"
# ─────────────────────────────────────────────────────────────────────────────

df <- read_excel(INPUT_FILE, sheet = "UD_averages_totals")
followers <- read.csv(FOLLOWERS_FILE) %>% select(ID, followers)

metrics <- c("likes", "reposts", "replies", "views")

# Every metric shares the same count columns, so one paired sample serves all four
paired <- df %>%
  filter(SH_total_tweet_count > 0 & non_SH_tweet_count > 0) %>%
  left_join(followers, by = "ID")
cat("Paired accounts:", nrow(paired), "\n")
cat("  with no follower count (left out of the follower ranking only):",
    sum(is.na(paired$followers)), "\n\n")

# ── Highest-engagement accounts, by overall average views per post ───────────
ranked <- paired %>% arrange(desc(total_tweet_views_avg))
top_ids <- ranked$ID[1:3]
cat("Top accounts by overall views/post (console only, not for publication):\n")
print(ranked %>% slice(1:5) %>%
        select(ID, total_tweet_views_avg, total_tweet_likes_avg) %>%
        mutate(x_median_views = round(total_tweet_views_avg / median(paired$total_tweet_views_avg), 1),
               x_median_likes = round(total_tweet_likes_avg / median(paired$total_tweet_likes_avg), 1)))
cat("\n")

# ── Accounts with the most followers ─────────────────────────────────────────
by_followers <- paired %>% filter(!is.na(followers)) %>% arrange(desc(followers))
top_follower_ids <- by_followers$ID[1:2]
cat("Top accounts by followers (console only, not for publication):\n")
print(by_followers %>% slice(1:5) %>%
        select(ID, followers) %>%
        mutate(x_median_followers = round(followers / median(by_followers$followers), 1),
               rank_views = match(ID, ranked$ID)))
cat("Top 2 by followers are the same accounts as top 2 by views/post:",
    setequal(top_follower_ids, top_ids[1:2]), "\n\n")

# ── One metric, one sample: same test as the primary analysis ────────────────
test_metric <- function(d, metric) {
  sh  <- d[[paste0("SH_", metric, "_avg")]]
  nsh <- d[[paste0("non_SH_", metric, "_avg")]]
  n   <- length(sh)
  diffs <- sh - nsh

  test <- wilcox.test(sh, nsh, paired = TRUE, exact = FALSE, conf.int = TRUE)
  r    <- as.numeric(wilcoxonPairedR(
            x = c(sh, nsh),
            g = factor(rep(c("SH", "non_SH"), each = n), levels = c("SH", "non_SH"))))
  sign <- binom.test(sum(diffs > 0), sum(diffs != 0), p = 0.5)
  pratt <- wilcoxsign_test(sh ~ nsh, data = data.frame(sh, nsh),
                           zero.method = "Pratt", distribution = "asymptotic")

  data.frame(metric         = metric,
             n_pairs        = n,
             pct_SH_higher  = round(100 * mean(diffs > 0), 1),
             SH_median      = round(median(sh), 2),
             non_SH_median  = round(median(nsh), 2),
             mean_diff      = round(mean(diffs), 2),
             HL_estimate    = round(unname(test$estimate), 2),
             CI_lower       = round(test$conf.int[1], 2),
             CI_upper       = round(test$conf.int[2], 2),
             W_statistic    = unname(test$statistic),
             p_value        = test$p.value,
             effect_size_r  = round(r, 3),
             sign_test_p    = sign$p.value,
             pratt_p        = as.numeric(pvalue(pratt)))
}

# Four metrics, Holm across them (same family as the primary analysis)
run_family <- function(d) {
  bind_rows(lapply(metrics, function(m) test_metric(d, m))) %>%
    mutate(p_holm      = p.adjust(p_value, method = "holm"),
           sign_p_holm = p.adjust(sign_test_p, method = "holm"),
           pratt_p_holm = p.adjust(pratt_p, method = "holm"),
           significant = p_holm < .05,
           significant_pratt = pratt_p_holm < .05)
}

# ── 2. Sensitivity scenarios ─────────────────────────────────────────────────
scenarios <- list(
  "Primary (all paired accounts)"      = paired,
  "Excluding top 2 follower accounts"   = paired %>% filter(!ID %in% top_follower_ids),
  "Excluding top 2 engagement accounts" = paired %>% filter(!ID %in% top_ids[1:2]),
  "Excluding top 3 engagement accounts" = paired %>% filter(!ID %in% top_ids[1:3])
)

sens <- bind_rows(lapply(names(scenarios), function(s) {
  cbind(scenario = s, run_family(scenarios[[s]]))
}))

cat("--- Sensitivity ---\n")
print(sens %>% mutate(across(c(p_value, p_holm, sign_test_p, sign_p_holm,
                                pratt_p, pratt_p_holm), ~ signif(.x, 3))),
      row.names = FALSE)

# ── 3. Leave-one-out ─────────────────────────────────────────────────────────
loo <- bind_rows(lapply(paired$ID, function(id) {
  cbind(dropped = id, run_family(paired %>% filter(ID != id)))
}))

loo_summary <- loo %>%
  group_by(metric) %>%
  summarise(n_runs           = n(),
            r_min            = min(effect_size_r),
            r_max            = max(effect_size_r),
            HL_min           = min(HL_estimate),
            HL_max           = max(HL_estimate),
            p_holm_max       = signif(max(p_holm), 3),
            runs_significant = sum(significant),
            runs_significant_pratt = sum(significant_pratt),
            .groups = "drop")

cat("\n--- Leave-one-out ---\n")
print(loo_summary, row.names = FALSE)

# ── 1. Distribution diagnostics for the test choice ──────────────────────────
skew <- function(x) mean((x - mean(x))^3) / sd(x)^3
exkurt <- function(x) mean((x - mean(x))^4) / sd(x)^4 - 3

diagnostics <- bind_rows(lapply(metrics, function(m) {
  diffs <- paired[[paste0("SH_", m, "_avg")]] - paired[[paste0("non_SH_", m, "_avg")]]
  top2  <- paired$ID %in% top_ids[1:2]
  sw    <- shapiro.test(diffs)
  data.frame(metric               = m,
             skewness             = round(skew(diffs), 2),
             excess_kurtosis      = round(exkurt(diffs), 2),
             shapiro_W            = round(unname(sw$statistic), 3),
             shapiro_p            = signif(sw$p.value, 3),
             pct_zero_diff        = round(100 * mean(diffs == 0), 1),
             mean_diff            = round(mean(diffs), 2),
             median_diff          = round(median(diffs), 2),
             mean_to_median       = round(mean(diffs) / median(diffs), 1),
             pct_sum_diff_top2    = round(100 * sum(diffs[top2]) / sum(diffs), 1),
             mean_diff_excl_top2  = round(mean(diffs[!top2]), 2))
}))

cat("\n--- Diagnostics (paired differences, SH minus non-SH) ---\n")
print(diagnostics, row.names = FALSE)
