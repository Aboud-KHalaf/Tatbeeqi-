-- SQL function to update user streak when a lesson is completed
-- This should be executed in Supabase SQL Editor

CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_today DATE := CURRENT_DATE;
    v_yesterday DATE := CURRENT_DATE - INTERVAL '1 day';
    v_current_streak INTEGER := 0;
    v_longest_streak INTEGER := 0;
    v_last_completed_date DATE;
    v_streak_record RECORD;
BEGIN
    -- Get current streak data
    SELECT current_streak, longest_streak, last_completed_date
    INTO v_current_streak, v_longest_streak, v_last_completed_date
    FROM user_streaks
    WHERE user_id = p_user_id;
    
    -- If no record exists, create one
    IF NOT FOUND THEN
        INSERT INTO user_streaks (user_id, current_streak, longest_streak, last_completed_date)
        VALUES (p_user_id, 1, 1, v_today);
        RETURN;
    END IF;
    
    -- If already completed today, don't update
    IF v_last_completed_date = v_today THEN
        RETURN;
    END IF;
    
    -- Update streak logic
    IF v_last_completed_date = v_yesterday THEN
        -- Continue streak
        v_current_streak := v_current_streak + 1;
    ELSIF v_last_completed_date IS NULL OR v_last_completed_date < v_yesterday THEN
        -- Start new streak
        v_current_streak := 1;
    END IF;
    
    -- Update longest streak if current is greater
    IF v_current_streak > v_longest_streak THEN
        v_longest_streak := v_current_streak;
    END IF;
    
    -- Update the record
    UPDATE user_streaks
    SET 
        current_streak = v_current_streak,
        longest_streak = v_longest_streak,
        last_completed_date = v_today
    WHERE user_id = p_user_id;
    
END;
$$;
