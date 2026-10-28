# SH_vs_nonSH_analysis.R
# -----------------------
# Reads UD_averages_totals.xlsx and runs Wilcoxon signed-rank tests
# comparing SH vs. non-SH average engagement metrics across user accounts.
# Also computes paired Wilcoxon r effect size via rcompanion.
#
# Tests are paired by user ID (each user contributes one SH avg and one non-SH avg).
# Users with 0 in either SH_count or non_SH_count are excluded from that metric's
# test, since a 0 average could mean no data rather than true zero engagement.
#
# The four tests (likes, reposts, replies, views) share the same accounts and
# form one confirmatory family, so significance is judged on Holm-adjusted p
# (per the IRB statistical analysis plan).
#
# Direction is read from the Hodges-Lehmann estimate of the paired difference
# (SH minus non-SH), not from the two group medians: with many zero counts the
# group medians can point the opposite way to the test (e.g. reposts).
#
# Effect size: rcompanion::wilcoxonPairedR() takes long-format data
# (x = all values, g = 2-level group, pairs in matching order). Passing the two
# vectors as (x, g) silently produces wrong values. Zero differences are
# dropped from n (adjustn = TRUE), matching wilcox.test's zero handling.
#
# Results are printed to the console; no files are written.
#
# Required packages: readxl, dplyr, tidyr, broom, rcompanion
# Install if needed:
#   install.packages(c("readxl", "dplyr", "tidyr", "broom", "rcompanion"))

library(readxl)
library(dplyr)
library(tidyr)
library(broom)
library(rcompanion)

# ── Input ─────────────────────────────────────────────────────────────────────
# Code shown for transparency. The account-level data are not public
# (IRB data-protection plan), so this script will not run as-is.
INPUT_FILE <- "UD_averages_totals.xlsx"
# ─────────────────────────────────────────────────────────────────────────────

# ── Load data ─────────────────────────────────────────────────────────────────
df <- read_excel(INPUT_FILE, sheet = "UD_averages_totals")

cat("Loaded", nrow(df), "user accounts.\n\n")

# ── Metric pairs to compare (SH column vs non-SH column) ─────────────────────
metric_pairs <- list(
  list(metric    = "likes",
       sh_col    = "SH_likes_avg",
       nsh_col   = "non_SH_likes_avg",
       sh_count  = "SH_total_tweet_count",
       nsh_count = "non_SH_tweet_count"),

  list(metric    = "reposts",
       sh_col    = "SH_reposts_avg",
       nsh_col   = "non_SH_reposts_avg",
       sh_count  = "SH_total_tweet_count",
       nsh_count = "non_SH_tweet_count"),

  list(metric    = "replies",
       sh_col    = "SH_replies_avg",
       nsh_col   = "non_SH_replies_avg",
       sh_count  = "SH_total_tweet_count",
       nsh_count = "non_SH_tweet_count"),

  list(metric    = "views",
       sh_col    = "SH_views_avg",
       nsh_col   = "non_SH_views_avg",
       sh_count  = "SH_total_tweet_count",
       nsh_count = "non_SH_tweet_count")
)

# ── Run tests ─────────────────────────────────────────────────────────────────
results <- lapply(metric_pairs, function(m) {

  # Keep only users who have data in BOTH groups for this metric
  valid <- df %>%
    filter(.data[[m$sh_count]] > 0 & .data[[m$nsh_count]] > 0) %>%
    select(ID,
           sh  = all_of(m$sh_col),
           nsh = all_of(m$nsh_col))

  n <- nrow(valid)

  if (n < 3) {
    cat(sprintf("%-10s — not enough paired users (n = %d), skipping.\n", m$metric, n))
    return(NULL)
  }

  # ── Wilcoxon signed-rank test ─────────────────────────────────────────────
  test <- wilcox.test(valid$sh, valid$nsh,
                      paired   = TRUE,
                      exact    = FALSE,
                      conf.int = TRUE)

  # ── Effect size: paired Wilcoxon r (rcompanion, long format) ──────────────
  long_x <- c(valid$sh, valid$nsh)
  long_g <- factor(rep(c("SH", "non_SH"), each = n), levels = c("SH", "non_SH"))
  r_value <- as.numeric(wilcoxonPairedR(x = long_x, g = long_g))

  # Interpret r: small ≥ 0.1, medium ≥ 0.3, large ≥ 0.5
  r_label <- ifelse(abs(r_value) >= 0.5, "large",
             ifelse(abs(r_value) >= 0.3, "medium",
             ifelse(abs(r_value) >= 0.1, "small", "negligible")))

  diffs      <- valid$sh - valid$nsh
  hl_est     <- unname(test$estimate)
  sh_median  <- median(valid$sh,  na.rm = TRUE)
  nsh_median <- median(valid$nsh, na.rm = TRUE)
  sh_mean    <- mean(valid$sh,    na.rm = TRUE)
  nsh_mean   <- mean(valid$nsh,   na.rm = TRUE)

  direction <- ifelse(hl_est > 0, "SH > non-SH",
               ifelse(hl_est < 0, "SH < non-SH", "no difference"))

  data.frame(
    metric           = m$metric,
    n_pairs          = n,
    n_nonzero_diff   = sum(diffs != 0),
    pct_SH_higher    = round(100 * mean(diffs > 0), 1),
    pct_tied         = round(100 * mean(diffs == 0), 1),
    SH_mean          = round(sh_mean,    2),
    non_SH_mean      = round(nsh_mean,   2),
    SH_median        = round(sh_median,  2),
    non_SH_median    = round(nsh_median, 2),
    HL_estimate      = round(hl_est, 2),
    CI_lower         = round(test$conf.int[1], 2),
    CI_upper         = round(test$conf.int[2], 2),
    direction        = direction,
    W_statistic      = unname(test$statistic),
    p_value          = test$p.value,
    effect_size_r    = round(r_value, 3),
    effect_magnitude = r_label
  )
})

# ── Combine, Holm-adjust across the four metrics, and print ───────────────────
results_df <- bind_rows(Filter(Negate(is.null), results)) %>%
  mutate(p_holm      = p.adjust(p_value, method = "holm"),
         significant = p_holm < .05,
         p_value     = signif(p_value, 4),
         p_holm      = signif(p_holm, 4))

stars <- function(p) ifelse(p < .001, " ***", ifelse(p < .01, " **", ifelse(p < .05, " *", "")))
for (i in seq_len(nrow(results_df))) {
  r <- results_df[i, ]
  cat(sprintf(
    "%-8s | n = %2d | SH median = %8.2f | non-SH median = %8.2f | HL = %7.2f | %s | W = %6.1f | p = %.4f | Holm p = %.4f%s | r = %.3f (%s)\n",
    r$metric, r$n_pairs, r$SH_median, r$non_SH_median, r$HL_estimate, r$direction,
    r$W_statistic, r$p_value, r$p_holm, stars(r$p_holm), r$effect_size_r, r$effect_magnitude
  ))
}

cat("\n--- Summary ---\n")
print(results_df, row.names = FALSE)
