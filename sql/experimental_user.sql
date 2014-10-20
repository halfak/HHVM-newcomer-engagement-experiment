SELECT
    wiki,
    event_userId AS user_id,
    timestamp AS user_registration,
    event_displayMobile AS display_mobile,
    event_isSelfMade AS new_user
FROM log.ServerSideAccountCreation_5487345
INNER JOIN staging.wiki_info USING(wiki)
WHERE
    code = "wiki" AND
    timestamp BETWEEN "20141008000000" AND "20141015999999"
ORDER BY wiki, timestamp;
