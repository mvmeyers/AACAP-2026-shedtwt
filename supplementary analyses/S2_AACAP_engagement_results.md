# Supplement S2. Engagement on self-harm posts: full results and sensitivity analysis

**AACAP 2026 poster · #shedtwt engagement analysis**

This supplement gives the full statistical results behind the engagement
panel of the AACAP 2026 poster. The poster reports a summary row for each
metric. Here are all four metrics (views, likes, replies, reposts) with the
full Wilcoxon output, plus a sensitivity analysis that re-runs everything
without the two accounts with the most followers.

| | |
|---|---|
| Poster and other materials | [Repository README](../README.md) |
| Primary analysis code | [`code/SH_vs_nonSH_analysis.R`](../code/SH_vs_nonSH_analysis.R) |
| Sensitivity analysis code | [`code/SH_vs_nonSH_sensitivity.R`](../code/SH_vs_nonSH_sensitivity.R) |
| Test choice and further robustness checks | [Supplement S1](S1_engagement_sensitivity_and_test_choice.md) |

## Key findings

- **Self-harm (SH) posts got more engagement than the same account's other
  posts.** The effect is large for views (*r* = .76) and likes (*r* = .77),
  large for replies (*r* = .53), and medium for reposts (*r* = .37). All four
  are significant after Holm correction.
- **Most accounts showed it.** 87% of accounts had more views on their SH
  posts and 80% had more likes.
- **Views, likes and replies do not depend on the most-followed accounts.**
  Without the two accounts with the most followers, the effect sizes barely
  move (views .76 → .75, likes .77 → .76, replies .53 → .50), and all three
  stay significant.
- **The repost result is fragile.** Most accounts get almost no reposts on
  either kind of post. The repost effect loses significance when the two
  most-followed accounts are excluded (Holm *p* = .10), and the sign test
  is not significant even in the full sample. Neither is the signed-rank
  test once tied accounts are kept in (Pratt; Holm *p* = .15). Report it
  as weak.

## Method summary

- **Sample.** 45 of the 74 coded accounts had at least one SH disclosure
  post *and* at least one other original post in the collection window.
  These 45 accounts posted 289 SH posts (median 5 per account, range 1–35)
  and 1,689 other original posts.
- **Unit of analysis: the account.** For each account we averaged each
  metric separately over its SH posts and over its other posts. Each account
  is compared with itself, which removes large differences in baseline reach
  between accounts.
- **Test.** Paired Wilcoxon signed-rank test, one per metric, using the
  normal approximation with continuity and tie correction. Pairs with a zero
  difference are dropped; Pratt's method, which keeps them, is a sensitivity
  check in Supplement S1. The four metrics form one family, and significance
  is judged on **Holm-adjusted** *p* values.
- **Effect size.** Paired Wilcoxon *r* = *Z* / √*n*, where *n* is the number
  of accounts with a nonzero difference (`rcompanion::wilcoxonPairedR`).
  Read as small ≥ .10, medium ≥ .30, large ≥ .50.
- **Size and direction of the effect.** The Hodges–Lehmann (HL) estimate of
  the paired difference (SH minus other posts) with its 95% CI. A positive HL
  means more engagement on SH posts.
- **Check without the symmetry assumption.** An exact sign test on the number of accounts
  higher vs. lower on SH posts, Holm-adjusted across the four metrics.

Why a signed-rank test and not a paired *t*-test: the within-account
differences are extremely skewed (skewness 2.8–6.2, Shapiro–Wilk *p* < .001
for every metric), and the mean difference is mostly carried by two
accounts. See [Supplement S1, §S1.2](S1_engagement_sensitivity_and_test_choice.md#s12-why-a-wilcoxon-signed-rank-test).

## 1. Primary analysis: all four metrics

### Table S2.1. Descriptive statistics (*n* = 45 accounts)

Account-level averages per post. "Other" = the account's other original
posts. Direction counts are accounts whose SH average was higher, lower, or
equal to their other-post average.

| Metric  | Other posts: mean | SH posts: mean | Other posts: median | SH posts: median | SH higher | SH lower | Tied |
|---------|------------------:|---------------:|--------------------:|-----------------:|----------:|---------:|-----:|
| Views   | 200.70 | 698.99 | 58.20 | 106.00 | 39 (86.7%) | 6 | 0 |
| Likes   |   5.89 |  16.69 |  1.33 |   3.50 | 36 (80.0%) | 6 | 3 |
| Replies |   0.30 |   0.74 |  0.17 |   0.38 | 28 (62.2%) | 11 | 6 |
| Reposts |   0.86 |   1.57 |  0.05 |   0.00 | 17 (37.8%) | 14 | 14 |

Means are shown for completeness but are dominated by a few accounts (see
§2). The test is based on the paired differences, not on these group
summaries.

### Table S2.2. Wilcoxon signed-rank tests (*n* = 45 accounts)

| Metric  | Nonzero pairs | HL estimate [95% CI] | *W* | *p* | Holm *p* | *r* | Magnitude | Sign test, Holm *p* |
|---------|--------------:|---------------------|----:|----:|---------:|----:|-----------|--------------------:|
| Views   | 45 | 81.12 [42.07, 141.71] | 968.0 | < .001 | < .001 | .76 | Large  | < .001 |
| Likes   | 42 |  1.88 [1.18, 3.18]    | 851.5 | < .001 | < .001 | .77 | Large  | < .001 |
| Replies | 39 |  0.22 [0.09, 0.44]    | 628.5 | < .001 | .002   | .53 | Large  | .019   |
| Reposts | 31 |  0.05 [0.00, 0.23]    | 353.0 | .041   | .041   | .37 | Medium | .72    |

Unadjusted *p* values, unrounded: views 3.8 × 10⁻⁷, likes 5.9 × 10⁻⁷, replies
9.0 × 10⁻⁴, reposts .041.

**Reading the reposts row.** The group medians (0.05 → 0.00) point the
opposite way to the HL estimate (+0.05) because 14 of 45 accounts are tied
and most averages are at or near zero. The direction comes from the paired
differences, which favour SH posts. The sign test (17 higher vs. 14 lower)
cannot tell the two directions apart.

## 2. Sensitivity analysis: excluding the two most-followed accounts

### Why and how

Engagement scales with audience size. If a few accounts with large
followings drove the result, the effect would describe them, not the
typical account. We re-ran the primary analysis without the **two accounts
with the most followers**.

- **Follower counts** were read from each account's profile screenshot.
  Counts came from two OCR passes that agreed, or from manual review where
  they did not.
- **Ranking.** Among the 45 paired accounts, the median follower count was
  84. The two most-followed accounts had about **15×** and **13×** that
  median. The next account had about 9×.
- One paired account had no readable follower count. It was kept in the
  analysis and left out of the ranking only. It ranks 39th of 45 on views per
  post, so it is very unlikely to be a top-follower account.
- **The same two accounts are also the top two on views per post and on
  likes per post.** This exclusion is therefore identical to the
  "top 2 engagement accounts" exclusion in Supplement S1.
- Everything else (test, Holm family, effect size) is unchanged. Accounts
  were selected by rule, not by hand. To protect participants, this document
  describes them only by rank and relative size, not by study ID or exact
  counts.

### Table S2.3. Primary vs. excluding the two most-followed accounts

| Metric | Sample | *n* | SH higher | Median, other → SH | HL [95% CI] | *W* | Holm *p* | *r* | Sign test, Holm *p* |
|---|---|---:|---:|---|---|---:|---:|---:|---:|
| **Views**   | All accounts         | 45 | 86.7% | 58.2 → 106.0 | 81.12 [42.07, 141.71] | 968.0 | < .001 | .76 | < .001 |
|             | Excl. top 2 followed | 43 | 86.0% | 57.0 → 105.6 | 67.04 [36.23, 112.12] | 879.0 | < .001 | .75 | < .001 |
| **Likes**   | All accounts         | 45 | 80.0% | 1.33 → 3.50  | 1.88 [1.18, 3.18]     | 851.5 | < .001 | .77 | < .001 |
|             | Excl. top 2 followed | 43 | 79.1% | 1.26 → 3.20  | 1.69 [1.03, 2.66]     | 768.5 | < .001 | .76 | < .001 |
| **Replies** | All accounts         | 45 | 62.2% | 0.17 → 0.38  | 0.22 [0.09, 0.44]     | 628.5 | .002   | .53 | .019   |
|             | Excl. top 2 followed | 43 | 60.5% | 0.17 → 0.36  | 0.18 [0.06, 0.35]     | 551.5 | .005   | .50 | .040   |
| **Reposts** | All accounts         | 45 | 37.8% | 0.05 → 0.00  | 0.05 [0.00, 0.23]     | 353.0 | .041   | .37 | .72    |
|             | Excl. top 2 followed | 43 | 34.9% | 0.04 → 0.00  | 0.03 [−0.02, 0.18]    | 294.0 | .10    | .31 | 1.00   |

Both excluded accounts were higher on SH posts for all four metrics. Their
removal leaves the count of accounts lower or tied unchanged.

### Table S2.4. What the two accounts do to the mean, and what they don't do to the test

The mean paired difference (SH minus other posts) is what a paired *t*-test
would test. The HL estimate and *r* are what the signed-rank test reports.

| Metric  | Mean diff., all 45 | Mean diff., excl. top 2 | Change in mean | HL, all → excl. | *r*, all → excl. |
|---------|-------------------:|------------------------:|---------------:|----------------:|-----------------:|
| Views   | 498.29 | 132.19 | −73% | 81.12 → 67.04 | .76 → .75 |
| Likes   |  10.80 |   3.44 | −68% | 1.88 → 1.69   | .77 → .76 |
| Replies |   0.44 |   0.28 | −36% | 0.22 → 0.18   | .53 → .50 |
| Reposts |   0.71 |   0.15 | −79% | 0.05 → 0.03   | .37 → .31 |

Two accounts (4% of the sample) supply most of the mean difference in views,
likes and reposts. Removing them barely moves the rank-based results. This
is why the analysis uses the signed-rank test: it describes the typical
account.

### Table S2.5. Leave-one-out check

As a broader check, the primary analysis was re-run 45 times, each time
without a different account.

| Metric  | *r* range | HL range | Largest Holm *p* | Runs significant (of 45) |
|---------|-----------|----------|-----------------:|-------------------------:|
| Views   | .75 – .81 | 72.6 – 87.8 | < .001 | 45 |
| Likes   | .77 – .81 | 1.79 – 1.98 | < .001 | 45 |
| Replies | .52 – .58 | 0.20 – 0.24 | .003   | 45 |
| Reposts | .34 – .43 | 0.03 – 0.06 | .067   | 30 |

### Interpretation

- **Views and likes: robust.** The effect is large with or without the two
  most-followed accounts. About 86% (views) and 79% (likes) of accounts were
  still higher on SH posts, both CIs stay well above zero, and the sign test
  agrees. No single account changes the conclusion.
- **Replies: robust, smaller effect.** The effect stays significant (Holm
  *p* = .005). It moves from large to the medium/large boundary
  (*r* = .496), and the sign test is still significant (*p* = .040).
- **Reposts: not robust.** The effect loses significance without the two
  most-followed accounts (Holm *p* = .10, CI includes zero). It also loses
  significance in 15 of 45 leave-one-out runs, and the sign test is
  non-significant in every sample. With Pratt's zero handling it is not
  significant in the full sample (Holm *p* = .15) or in any of the 45
  leave-one-out runs ([Supplement S1](S1_engagement_sensitivity_and_test_choice.md),
  Tables S1.3 and S1.4). Treat the repost finding as weak and driven by a
  few accounts.

## Code

The code is shown for transparency.

- Tables S2.1–S2.2 come from
  [`code/SH_vs_nonSH_analysis.R`](../code/SH_vs_nonSH_analysis.R).
- Tables S2.3–S2.5 come from
  [`code/SH_vs_nonSH_sensitivity.R`](../code/SH_vs_nonSH_sensitivity.R).
  The follower exclusion is the scenario `Excluding top 2 follower accounts`.

Both scripts run on an account-level summary built from the coded posts in
the study's private pipeline.

The account-level data are not in this public
repository. They are keyed by internal study ID and are protected by the study. To limit re-identification risk, this
supplement describes the excluded accounts only by rank and by their
engagement and follower counts relative to the median account. It does not give study IDs or
their exact engagement figures.

R 4.6.1; packages readxl, dplyr, tidyr, broom, rcompanion, coin.

## AI Statement

**Use of AI tools.** We used Claude (Opus 5.5; Anthropic), through Claude Code,
to help write and revise the R analysis code and draft and edit the text of this
supplement. The authors chose the analyses,
re-ran all code and checked every reported number in R 4.6.1, and take full
responsibility for the content. Claude is not an author.