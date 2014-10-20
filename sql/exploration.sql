

SELECT
    event_isSelfMade,
    event_displayMobile,
    wiki,
    event_userId % 2,
    ct_tag,
    count(*)
FROM log.ServerSideAccountCreation_5487345
INNER JOIN enwiki.revision ON
    rev_user = event_userId
INNER JOIN enwiki.change_tag ON
    rev_id = ct_rev_id
WHERE
    wiki = "enwiki" AND
    timestamp BETWEEN "20141008000000" AND "20141015999999" AND
    ct_tag = "HHVM"
GROUP BY 1,2,3,4,5;
