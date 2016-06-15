/**
INSERT INTO
	users(id, username, password)
VALUES
	('95ef2f42-3320-11e6-ac61-9e71128cae77', 'ivoneijr', 'pass' );


INSERT INTO
	oauth_clients(client_id, client_secret, redirect_uri)
VALUES
	(1, 'secrect', 'http://www.google.com.br');



INSERT INTO
	oauth_tokens(id, access_token, refresh_token, client_id, user_id,access_token_expires_on,refresh_token_expires_on)
VALUES
	('06ef3f53-4431-22e7-ac72-0e82239cae88', 'acctoken', 'reftoken', 1, '95ef2f42-3320-11e6-ac61-9e71128cae77','2015-07-02','2015-07-02');

**/
