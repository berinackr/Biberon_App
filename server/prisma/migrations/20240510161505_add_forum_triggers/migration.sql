CREATE OR REPLACE FUNCTION update_post_last_activity_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.parent_id IS NOT NULL THEN 
        UPDATE post
        SET last_activity_date = CURRENT_TIMESTAMP
        WHERE id = NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_post_last_activity_date_on_comment()
RETURNS TRIGGER AS $$
BEGIN
    -- update the parentId post's last_activity_date too
    UPDATE post
    SET last_activity_date = CURRENT_TIMESTAMP
    WHERE id = NEW.post_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_post_updated_at
BEFORE UPDATE ON post
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER tr_update_comment_updated_at
BEFORE UPDATE ON comment
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_post_last_activity_date_trigger
AFTER INSERT OR UPDATE ON post
FOR EACH ROW
EXECUTE FUNCTION update_post_last_activity_date();

CREATE TRIGGER update_post_last_activity_date_on_comment_trigger
AFTER INSERT ON comment
FOR EACH ROW
EXECUTE FUNCTION update_post_last_activity_date_on_comment();