DEFINE ACCESS OVERWRITE account
  ON DATABASE
  TYPE RECORD
  SIGNIN (
    SELECT id FROM user
    WHERE
      email = $email
      AND
      password_hash = crypto::argon2::compare(password_hash, $password)
  )
  DURATION
    FOR SESSION 4h
    FOR TOKEN 8h;

DEFINE TABLE OVERWRITE user SCHEMAFULL
  PERMISSIONS
    FOR select, update WHERE id = $auth
    FOR select, create, update, delete WHERE $auth.is_admin;

DEFINE FIELD OVERWRITE name ON TABLE user TYPE string;
DEFINE FIELD OVERWRITE email ON TABLE user TYPE string ASSERT $value.is_email();
DEFINE FIELD OVERWRITE password_hash ON TABLE user TYPE string ASSERT $value.starts_with("$argon2");
DEFINE FIELD OVERWRITE is_admin ON TABLE user TYPE bool DEFAULT false;
DEFINE FIELD OVERWRITE language ON TABLE user TYPE "EnUS" | "EsCR" DEFAULT "EsCR";
DEFINE FIELD OVERWRITE theme ON TABLE user TYPE "light" | "dark" DEFAULT "dark";