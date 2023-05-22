CREATE OR REPLACE FUNCTION updateview(
	oldTable ticket_for_user,
	newTable ticket_for_user
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE tickets
			SET price = newTable.price WHERE ticket_id = oldTable.ticket_id;
	END;
$BODY$
LANGUAGE plpgsql;

CREATE RULE update_view AS
ON UPDATE TO ticket_for_user DO INSTEAD(
	SELECT updateview(OLD, NEW));