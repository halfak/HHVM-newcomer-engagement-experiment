dbstore = --defaults-file=~/.my.research.cnf -h analytics-store.eqiad.wmnet \
-u research


datasets/experimental_user.tsv: sql/experimental_user.sql
	cat sql/experimental_user.sql | \
	mysql $(dbstore) > \
	datasets/experimental_user.tsv

datasets/experimental_user_stats.tsv: datasets/experimental_user.tsv \
                                      hhvm/user_stats.py
	cat datasets/experimental_user.tsv | \
	./user_stats --user research > \
	datasets/experimental_user_stats.tsv
