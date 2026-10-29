# Supplement S1. Engagement analysis: choice of test and sensitivity to high-engagement accounts

This supplement accompanies the primary engagement analysis, which compares
engagement on self-harm (SH) disclosure posts with engagement on the same
account's other posts. It explains why the analysis uses the paired Wilcoxon
signed-rank test and reports every sensitivity check run on the result.

The test choice (S1.2) rests on distribution diagnostics of the paired
differences: skewness, excess kurtosis, the Shapiro–Wilk test, the share of
zero differences, and how much of the mean difference comes from the two
highest-engagement accounts (Tables S1.1 and S1.2).

We ran five sensitivity checks on the primary result:

1. **Exact sign test** (S1.2, Table S1.3). The signed-rank test assumes the
   differences are roughly symmetric, and these are right-skewed. The sign
   test counts only how many accounts are higher on SH posts, so it holds
   whatever the shape of the differences.
2. **Pratt zero handling** (S1.2, Tables S1.3 and S1.4). Wilcoxon's
   procedure drops accounts with a zero difference, which removes 31% of
   accounts for reposts. Pratt's method keeps them in the ranking. Added
   after the primary analysis.
3. **Excluding the top 2 accounts by followers** (S1.3, Table S1.3). Two accounts carry
   about three-quarters of the SH advantage in views, likes and reposts.
   They are also the top 2 whether ranked by views, likes or followers.
4. **Excluding the top 3 accounts** (S1.3, Table S1.3). The third account
   by views per post is also well above the rest (about 20 times the median
   account).
5. **Leave-one-out** (S1.3, Table S1.4). The primary analysis re-run 45
   times, dropping each account once. The exclusions in checks 3 and 4 test
   only the largest accounts and depend on how "largest" is ranked.
   Leave-one-out tests every account by the same rule, so it would catch an
   account with modest engagement that still drives a result, such as the
   only account with a large difference in replies. It drops one account at
   a time, so checks 3 and 4 cover accounts that matter only together.

All numbers are computed for the 45 accounts that posted at least one SH
disclosure and at least one other original post during the collection
window. Code: [`code/SH_vs_nonSH_sensitivity.R`](../code/SH_vs_nonSH_sensitivity.R).
The primary analysis is [`code/SH_vs_nonSH_analysis.R`](../code/SH_vs_nonSH_analysis.R).

## S1.1 Analysis recap

- **Unit of analysis.** For each account we
  averaged views, likes, replies and reposts separately across its SH posts
  and across its other original posts. This gives one pair of values per
  account and avoids treating many posts from the same account as
  independent observations.
- **Test.** Paired Wilcoxon signed-rank test on the 45 pairs, one test per
  metric. We used the normal approximation with continuity and tie
  correction (R `wilcox.test(..., paired = TRUE, exact = FALSE)`). Pairs with
  a zero difference are dropped, following Wilcoxon's original procedure.
  Pratt's method, which keeps these pairs, is run as a sensitivity check (S1.2).
- **Multiplicity.** The four metrics form one family, so significance is
  judged on Holm-adjusted *p* values.
- **Effect size.** Paired Wilcoxon *r* = *Z* / √*n*, where *n* is the number
  of pairs with a nonzero difference (`rcompanion::wilcoxonPairedR`).
- **Location estimate.** The Hodges–Lehmann (HL) estimate of the paired
  difference, which is the median of all pairwise Walsh averages, with its
  95% confidence interval. The sign of HL gives the direction of the effect.

## S1.2 Why a Wilcoxon signed-rank test

### A paired design

Accounts differed greatly in number of engagements. Average views per post ranged
from about 11 to over 8,000 across the 45 accounts. Comparing SH posts with
other posts from different accounts would mostly measure differences between
accounts. Comparing each account with itself removes the large engagement difference at baseline.

### The differences are far from normal

**Table S1.1.** Distribution of the paired differences (SH average minus
other-post average), *n* = 45 accounts.

| Metric  | Skewness | Excess kurtosis | Shapiro–Wilk *W* | Shapiro–Wilk *p* | Zero differences | Mean diff. | Median diff. | Mean ÷ median |
|---------|---------:|----------------:|-----------------:|-----------------:|-----------------:|-----------:|-------------:|--------------:|
| Views   | 5.86 | 34.4 | 0.23 | < .001 | 0%    | 498.3 | 45.5 | 11.0 |
| Likes   | 4.60 | 21.7 | 0.31 | < .001 | 6.7%  | 10.80 | 1.67 | 6.5  |
| Replies | 2.79 | 9.2  | 0.68 | < .001 | 13.3% | 0.44  | 0.17 | 2.6  |
| Reposts | 6.15 | 37.1 | 0.21 | < .001 | 31.1% | 0.71  | 0.00 | —    |

Under normality, skewness and excess kurtosis are both near 0 and
Shapiro–Wilk *W* is near 1. Every metric departs sharply from this. Social
media engagement is typically heavy-tailed, since a few posts and accounts
get far more attention than the rest.

### The mean difference is carried by two accounts

A paired *t*-test tests the **mean** difference. In these data the mean is
mostly determined by two accounts. On overall views per post, these two
accounts sit at about 105 and 40 times the median account. The next account
is at 20 times, and every remaining account is under 5 times.

**Table S1.2.** Contribution of the two highest-engagement accounts to the
mean paired difference.

| Metric  | Share of summed difference from top 2 | Mean diff., all 45 | Mean diff., other 43 |
|---------|--------------------------------------:|-------------------:|---------------------:|
| Views   | 74.6% | 498.3 | 132.2 |
| Likes   | 69.6% | 10.80 | 3.44  |
| Replies | 39.4% | 0.44  | 0.28  |
| Reposts | 80.4% | 0.71  | 0.15  |

Two accounts, 4% of the sample, provide roughly three-quarters of the total
SH advantage in views, likes and reposts. Dropping them cuts the mean
difference in views by 73%. The median difference and the HL estimate move
far less (Table S1.3). A test of the mean would mostly describe these two
accounts, not the typical account. With kurtosis this extreme, *n* = 45 is
also too small to rely on the central limit theorem for valid *t*-test
inference.

### Properties of the signed-rank test that fit these data

- **Robust to extreme values.** It uses the ranks of the absolute
  differences. The largest difference counts as rank 45 whether it is 100
  views or 100,000.
- **Answers the question we care about.** It asks whether accounts
  typically get more engagement on SH posts. It does not ask whether
  engagement is higher on average once the most-followed accounts are added
  in.
- **Handles ties and zeros.** Many accounts average zero reposts on both
  post types. Zero differences are dropped and tied ranks are averaged,
  with a matching variance correction.
- **Keeps the paired design.**

### An assumption we checked: symmetry

The signed-rank test assumes the differences are roughly symmetric around
their center. Table S1.1 shows they are right-skewed, so we take two steps:

1. We report the **Hodges–Lehmann estimate** (the pseudo-median) as the
   location estimate. We do not report a difference in means.
2. We ran an **exact sign test** (binomial test on the number of accounts
   higher on SH posts, among accounts with a nonzero difference). It makes
   no assumption about the shape of the differences, at some cost in power.
   Results are in Table S1.3.

### A second check: how zero differences are handled

Wilcoxon's original procedure drops pairs with a zero difference before
ranking. Most of the time this matters little. Here it can matter, because
many accounts get the same average on both post types, almost always zero.
For reposts, 14 of 45 accounts (31%) are tied at zero (Table S1.1). Dropping
them leaves 31 accounts, and the test then asks only which way the accounts
that differ lean. The 14 tied accounts are evidence of *no* difference, and
that evidence is discarded.

Pratt's (1959) method keeps the zero differences when ranking the absolute
differences, then leaves them out of the signed-rank sum. The tied accounts
still shape the ranks and the variance, so a large share of ties pulls the
test toward "no difference." With many zeros it is the more conservative
choice.

This check was added after the primary analysis, during review of the
test assumptions. We re-ran
every scenario in Table S1.3 and every leave-one-out run in Table S1.4 with
Pratt's method (R `coin::wilcoxsign_test(..., zero.method = "Pratt",
distribution = "asymptotic")`), Holm-adjusted across the same four metrics.
The coin implementation has no continuity correction, which changes *p*
only slightly at *n* = 45.

## S1.3 Sensitivity analysis: excluding the highest-engagement accounts

We ranked the 45 paired accounts by overall average views per post and
re-ran the primary analysis three ways:

- with the top 2 accounts excluded, as specified;
- with the top 3 excluded, because the third account is also well above the
  rest on views;
- leaving out each of the 45 accounts in turn.

The exclusions follow a stated rule, not a choice of particular accounts.
The two top accounts are also the two highest on likes per post and on
follower count, so the top-2 exclusion is the same whichever of these is
used to rank (see [Supplement S2](S2_AACAP_engagement_results.md)). Everything
else, including the Holm family and the effect-size method, is the same as
in the primary analysis.

**Table S1.3.** Primary and sensitivity results. HL = Hodges–Lehmann
estimate of the paired difference (SH minus other posts) with 95% CI; % SH
higher = share of accounts with a higher SH average. Signed-rank drops zero
differences (Wilcoxon); Pratt keeps them in the ranking (S1.2).

| Sample | Metric | *n* | % SH higher | Median, other → SH | HL [95% CI] | Holm *p* (signed-rank) | *r* | Holm *p* (sign test) | Holm *p* (Pratt) |
|---|---|---:|---:|---|---|---:|---:|---:|---:|
| **Primary** | Views   | 45 | 86.7 | 58.2 → 106.0 | 81.1 [42.1, 141.7] | < .001 | .76 | < .001 | < .001 |
|  | Likes   | 45 | 80.0 | 1.33 → 3.50 | 1.88 [1.18, 3.18] | < .001 | .77 | < .001 | < .001 |
|  | Replies | 45 | 62.2 | 0.17 → 0.38 | 0.22 [0.09, 0.44] | .002 | .53 | .019 | .002 |
|  | Reposts | 45 | 37.8 | 0.05 → 0.00 | 0.05 [0.00, 0.23] | .041 | .37 | .72 | .15 |
| **Excl. top 2** | Views   | 43 | 86.0 | 57.0 → 105.6 | 67.0 [36.2, 112.1] | < .001 | .75 | < .001 | < .001 |
|  | Likes   | 43 | 79.1 | 1.26 → 3.20 | 1.69 [1.03, 2.66] | < .001 | .76 | < .001 | < .001 |
|  | Replies | 43 | 60.5 | 0.17 → 0.36 | 0.18 [0.06, 0.35] | .005 | .50 | .040 | .006 |
|  | Reposts | 43 | 34.9 | 0.04 → 0.00 | 0.03 [−0.02, 0.18] | .10 | .31 | 1.00 | .30 |
| **Excl. top 3** | Views   | 42 | 85.7 | 55.1 → 104.3 | 60.5 [34.2, 105.0] | < .001 | .74 | < .001 | < .001 |
|  | Likes   | 42 | 78.6 | 1.25 → 3.10 | 1.58 [1.00, 2.42] | < .001 | .76 | < .001 | < .001 |
|  | Replies | 42 | 59.5 | 0.17 → 0.34 | 0.16 [0.05, 0.31] | .009 | .48 | .058 | .010 |
|  | Reposts | 42 | 33.3 | 0.04 → 0.00 | 0.01 [−0.02, 0.14] | .16 | .27 | 1.00 | .43 |

For reposts, the group medians point the opposite way to HL because 31% of
accounts are tied at zero difference. The test and the direction are based
on the paired differences, not on the two medians.

**Table S1.4.** Leave-one-out: the primary analysis re-run 45 times, each
time without one account.

| Metric  | *r* range | HL range | Largest Holm *p* | Runs significant (of 45) | Runs significant, Pratt (of 45) |
|---------|-----------|----------|-----------------:|-------------------------:|--------------------------------:|
| Views   | .75 – .81 | 72.6 – 87.8 | < .001 | 45 | 45 |
| Likes   | .77 – .81 | 1.79 – 1.98 | < .001 | 45 | 45 |
| Replies | .52 – .58 | 0.20 – 0.24 | .003   | 45 | 45 |
| Reposts | .34 – .43 | 0.03 – 0.06 | .067   | 30 | 0  |

### Interpretation

- **Views and likes are robust.** Without the two highest-engagement
  accounts, the effect sizes barely change (*r* .76 → .75 for views, .77 →
  .76 for likes). The share of accounts higher on SH posts is unchanged, at
  about 86% and 79%. The HL estimates shrink somewhat but their confidence
  intervals stay well above zero. The sign test agrees. No single omitted
  account changes the conclusion. The SH advantage in views and likes
  reflects the typical account, not a few large ones.
- **Replies are robust, with a smaller effect.** The result stays
  significant under every exclusion and in all 45 leave-one-out runs. The
  effect shrinks modestly (*r* .53 → .50 → .48). The sign test is
  significant in the primary and top-2 samples, and borderline (*p* = .058)
  once three accounts are excluded.
- **Zero handling does not change views, likes or replies.** Pratt's method
  gives the same conclusion in every scenario and in all 45 leave-one-out
  runs. These metrics have few or no zero differences, so the two methods
  agree.
- **Reposts are not robust.** The primary repost result (Holm *p* = .041)
  is fragile:
  - it loses significance when the top 2 accounts are excluded (*p* = .10);
  - it loses significance in 15 of 45 leave-one-out runs;
  - the sign test is not significant even in the full sample (17 accounts
    higher on SH posts and 14 lower, *p* = .72);
  - it depends on dropping the 14 accounts tied at zero. With Pratt's
    method it is not significant in the full sample (*p* = .15), under
    either exclusion, or in any of the 45 leave-one-out runs.
  - Most accounts get almost no reposts on either kind of post, so this
    metric has little information to work with.

  The repost finding should be reported as weak and sensitive to a few
  accounts, not as evidence that SH posts are reposted more.

## S1.4 Code

The code is shown for transparency. All tables in this supplement come from
[`code/SH_vs_nonSH_sensitivity.R`](../code/SH_vs_nonSH_sensitivity.R):

- Tables S1.1 and S1.2: the distribution diagnostics.
- Table S1.3: the sensitivity scenarios, including the sign test and
  Pratt columns.
- Table S1.4: the leave-one-out runs, with and without Pratt's method.

The primary analysis is
[`code/SH_vs_nonSH_analysis.R`](../code/SH_vs_nonSH_analysis.R). Both scripts
run on an account-level summary built from the coded posts in the study's
private pipeline.

The account-level data are not in this public
repository. They are keyed by internal study ID and are protected by the study. To limit re-identification risk, this
supplement describes the excluded accounts only by rank and by their
engagement relative to the median account. It does not give study IDs or
their exact engagement figures.

R 4.6.1; packages readxl, dplyr, rcompanion, coin.

## AI Statement

**Use of AI tools.** We used Claude (Opus 5.5; Anthropic), through Claude Code,
to help write and revise the R analysis code and draft and edit the text of this
supplement. The authors chose the analyses,
re-ran all code and checked every reported number in R 4.6.1, and take full
responsibility for the content. Claude is not an author.

