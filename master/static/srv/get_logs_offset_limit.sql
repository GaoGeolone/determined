SELECT
    trial_logs.id AS id,
    trials.state AS state,
    CASE
      WHEN log IS NOT NULL THEN
        coalesce(to_char(timestamp, '[YYYY-MM-DD"T"HH24:MI:SS"Z"]' ), '[UNKNOWN TIME]')
        || ' '
        || coalesce(substring(container_id, 1, 8), '[UNKNOWN CONTAINER]')
        || coalesce(' [rank=' || (rank_id::text) || ']', '')
        || ' || '
        || coalesce(level || ': ', '')
        || encode(log, 'escape')
      ELSE encode(message, 'escape')
    END
    AS message
FROM trial_logs JOIN trials
ON trial_logs.trial_id = trials.id
WHERE trials.id = $1 AND trial_logs.id > $2
ORDER BY trial_logs.id ASC
LIMIT $3
