DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_sp`(IN `_username` VARCHAR(100), IN `_password` VARCHAR(100))
BEGIN

IF EXISTS(SELECT * FROM users WHERE username = _username AND password = MD5(_password))THEN

SELECT e.fullname,u.username,u.Role AS UserType,u.user_id AS id FROM users u 
JOIN employees e ON e.emp_id =u.emp_id
WHERE u.username = _username AND u.password = MD5(_password);

ELSE

SELECT 'Username or Password Incorrect' AS error;

END IF;

END$$
DELIMITER ;





DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `users_sp`(IN `_username` VARCHAR(100), IN `_password` VARCHAR(100), IN `_emp_id` INT, IN `_role_id` INT, IN `_reg_date` DATE)
BEGIN

IF EXISTS(SELECT user_id FROM users WHERE username = _username )THEN
SELECT concat('danger|',_username,' all ready Exist');
ELSE

INSERT INTO `users`(`emp_id`, `username`, `password`, `Role`, `user_date`)
VALUES(_emp_id,_username,MD5(_password),_role_id,_reg_date);

SELECT concat('success|',_username,' Registered');

END IF;
END$$
DELIMITER ;