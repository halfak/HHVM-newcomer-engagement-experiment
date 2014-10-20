source("loader/experimental_users.R")
source("loader/experimental_user_stats.R")

users = load_experimental_users(reload=T)
stats = load_experimental_user_stats(reload=T)

user_stats = merge(users, stats, by=c("wiki", "user_id"))

bucket_stats = user_stats[,
    list(
        n = length(user_id),
        editing.k = sum(day_revisions >= 1),
        day_revisions.geo.mean = geo.mean.plus.one(day_revisions),
        day_revisions.geo.se.upper =
            geo.se.upper.plus.one(day_revisions),
        day_revisions.geo.se.lower =
            geo.se.lower.plus.one(day_revisions),
        day_main_revisions.geo.mean = geo.mean.plus.one(day_main_revisions),
        day_main_revisions.geo.se.upper =
            geo.se.upper.plus.one(day_main_revisions),
        day_main_revisions.geo.se.lower =
            geo.se.lower.plus.one(day_main_revisions),
        second_day_revision.k = sum(day_revisions >= 2)
    ),
    list(
        bucket,
        ui_type,
        user_type
    )
]
bucket_stats$editing.prop = with(
    bucket_stats,
    editing.k/n
)
bucket_stats$editing.se = with(
    bucket_stats,
    sqrt(editing.prop*(1-editing.prop)/n)
)
bucket_stats$second_day_revision.prop = with(
    bucket_stats,
    second_day_revision.k/n
)
bucket_stats$second_day_revision.se = with(
    bucket_stats,
    sqrt(second_day_revision.prop*(1-second_day_revision.prop)/n)
)
bucket_stats$editing_second_day_revision.prop = with(
    bucket_stats,
    second_day_revision.k/editing.k
)
bucket_stats$editing_second_day_revision.se = with(
    bucket_stats,
    sqrt(
        editing_second_day_revision.prop *
        (1-editing_second_day_revision.prop)/editing.k
    )
)


svg("engagement/plots/day_revisions.new_users.by_bucket.by_registration_type.svg")
dev.off()

svg("engagement/plots/editing.new_users.by_bucket.by_registration_type.svg",
    height=5, width=4)
ggplot(
    bucket_stats[user_type=="new",],
    aes(
        x=bucket,
        y=editing.prop
    )
) +
facet_wrap(~ ui_type + user_type) +
geom_point() +
geom_errorbar(
    aes(
        ymax=editing.prop+editing.se,
        ymin=editing.prop-editing.se
    ),
    width=0.5
) +
theme_bw()
dev.off()

svg("engagement/plots/second_day_revision.new_users.by_bucket.by_registration_type.svg",
    height=5, width=4)
ggplot(
    bucket_stats[user_type=="new",],
    aes(
        x=bucket,
        y=second_day_revision.prop
    )
) +
facet_wrap(~ ui_type + user_type) +
geom_point() +
geom_errorbar(
    aes(
        ymax=second_day_revision.prop+second_day_revision.se,
        ymin=second_day_revision.prop-second_day_revision.se
    ),
    width=0.5
) +
theme_bw()
dev.off()

svg("engagement/plots/editing_second_day_revision.new_users.by_bucket.by_registration_type.svg",
    height=5, width=4)
ggplot(
    bucket_stats[user_type=="new",],
    aes(
        x=bucket,
        y=editing_second_day_revision.prop
    )
) +
facet_wrap(~ ui_type + user_type) +
geom_point() +
geom_errorbar(
    aes(
        ymax=editing_second_day_revision.prop+editing_second_day_revision.se,
        ymin=editing_second_day_revision.prop-editing_second_day_revision.se
    ),
    width=0.5
) +
theme_bw()
dev.off()
