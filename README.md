# When Nonsuicidal Self-Injury Facilitates Social Connection: Adolescent Engagement Within #shedtwt
## AACAP 2026 New Research Poster Supplementary Materials

Presenter: Margaret Meyers

Contact: veselin@unc.edu or mmeyers8549@gmail.com

CC-By Attribution 4.0

## Repository structure

```
.
├── README.md
├── poster pptx/      The poster (PowerPoint)
├── figures/          Poster figures (PNG)
├── supplementary/    Supplements S1 and S2 (Markdown)
└── code/             R scripts for the engagement analysis
```

## Contents

| Poster | |
|---|---|
| [Poster (.pptx)](poster%20pptx/When%20Nonsuicidal%20Self-Injury%20Facilitates%20Social%20Connection%20Adolescent%20Engagement%20Within%20%23shedtwt.pptx) | The AACAP 2026 poster |

| Supplement | What it covers |
|---|---|
| [S1. Test choice and sensitivity](supplementary/S1_engagement_sensitivity_and_test_choice.md) | Why the engagement analysis uses a paired Wilcoxon signed-rank test, and five sensitivity checks: sign test, Pratt zero handling, excluding the top 2 and top 3 accounts, and leave-one-out |
| [S2. Full engagement results](supplementary/S2_AACAP_engagement_results.md) | Full Wilcoxon results for views, likes, replies and reposts, and a sensitivity analysis excluding the two accounts with the most followers |

| Figure | |
|---|---|
| [Figure 1](figures/figure1_themes_of_social_support.png) | Three themes of social support found across shedtwt |
| [Figure 2](figures/figure2_likes_SH_vs_other_posts.png) | Likes on SH/ED photos vs. other posts, one line per account (n = 45) |

| Code | |
|---|---|
| [`code/SH_vs_nonSH_analysis.R`](code/SH_vs_nonSH_analysis.R) | Primary analysis: paired Wilcoxon signed-rank tests, Holm correction, effect sizes |
| [`code/SH_vs_nonSH_sensitivity.R`](code/SH_vs_nonSH_sensitivity.R) | Test-choice diagnostics, follower and engagement exclusions, leave-one-out, sign tests, Pratt zero handling |

## AI Statement

**Use of AI tools.** We used Claude (Opus 5.5; Anthropic), through Claude Code,
to help write and revise the R analysis code and draft and edit the text of this
supplement. The authors chose the analyses,
re-ran all code and checked every reported number in R 4.6.1, and take full
responsibility for the content. Claude is not an author.