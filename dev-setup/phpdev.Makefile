# 
# Copy in the root of the project as ".Makefile"
# Run as: `make -f .Makefile <target>`
# 

.SILENT:

DOCKER_COMPOSE_CMD = docker compose
# Set according to project
TARGET_CONTAINER = "php"

clear-cache-test:
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) bash -c "rm -rf var/cache/test"

run-tests-with-filter: clear-cache-test
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c "\
			SYMFONY_DEPRECATIONS_HELPER=weak \
			php \
				-dxdebug.mode=off \
				bin/phpunit \
				--no-logging \
				--no-coverage \
				--testdox \
				--do-not-cache-result \
				--filter $(TEST_FILTER) \
				--group ${TEST_GROUP} \
			"

run-tests-unit: clear-cache-test
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c "\
			SYMFONY_DEPRECATIONS_HELPER=weak \
			php \
				-dxdebug.mode=off \
				bin/phpunit \
				--no-logging \
				--no-coverage \
				--testdox \
				--do-not-cache-result \
				--exclude-group functional,panther \
			"

run-tests-functional: clear-cache-test
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c "\
			SYMFONY_DEPRECATIONS_HELPER=weak \
			php \
				-dxdebug.mode=off \
				bin/phpunit \
				--no-logging \
				--no-coverage \
				--do-not-cache-result \
				--group functional \
			"

run-tests-panther:
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c "\
			SYMFONY_DEPRECATIONS_HELPER=weak \
			PANTHER_NO_HEADLESS=0 \
			php \
				bin/phpunit \
				--no-logging \
				--no-coverage \
				--debug \
				--do-not-cache-result \
				--group panther \
				--filter $(TEST_FILTER) \
			"


# ######
# XDEBUG
# ######
XDEBUG_CONF = "/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
CMD_RESTART_PHP = "supervisorctl restart all"

xdebug-install:
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c '\
			php -v \
			&& pecl install xdebug \
		'

xdebug-on: xdebug-install
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c '\
			php -v \
		  && truncate -s0 $(XDEBUG_CONF) \
			&& echo "zend_extension=xdebug.so" > $(XDEBUG_CONF) \
			&& echo -e "\nxdebug.client_host=host.docker.internal\nxdebug.start_with_request=trigger\nxdebug.mode=debug" >> $(XDEBUG_CONF) \
			&& $(CMD_RESTART_PHP) \
			&& php -v \
			&& cat $(XDEBUG_CONF) \
		'

xdebug-off:
	$(DOCKER_COMPOSE_CMD) exec -it $(TARGET_CONTAINER) \
		bash -c '\
			php -v \
			&& truncate -s0 $(XDEBUG_CONF) \
			&& echo "zend_extension=xdebug.so" > $(XDEBUG_CONF) \
			&& echo -e "\nxdebug.mode=off" >> $(XDEBUG_CONF) \
			&& supervisorctl restart all \
			&& php -v \
			&& cat $(XDEBUG_CONF) \
		'


##############
# PHP CS Fixer
##############
CHANGED_FILES=$(shell git diff-index HEAD --name-only --diff-filter=AM ':*.php' ':!tests*' | tr "\n" " ")
php-cs-fixer-changed-files:
	git status -bs
	echo "--------------------------"
	echo "Changed files to analyse:" $(CHANGED_FILES)
	docker compose exec -it $(TARGET_CONTAINER) \
		bash -c "\
			php-cs-fixer fix $(DRY_RUN) -v --using-cache=no $(CHANGED_FILES) \
		"

php-cs-fixer-file:
	git status
	docker compose exec -it $(TARGET_CONTAINER) \
		bash -c "\
			php-cs-fixer fix $(DRY_RUN) -v --using-cache=no $(FILE) \
		"


################
# SQL query logs
################
CMD_SQL_LOGS_ON=\"SET global log_output='FILE'; SET global general_log_file='/var/log/mysqld.log'; SET global general_log=1;\"
CMD_SQL_LOGS_OFF=\"SET global general_log=0;\"
MYSQL_CONTAINER=mysql

sql-query-logs-on:
	docker exec -it ${MYSQL_CONTAINER} bash -c "mysql -u$(MYSQL_USER) -p$(MYSQL_PASS) -e $(CMD_SQL_LOGS_ON)"
sql-query-logs-off:
	docker exec -it ${MYSQL_CONTAINER} bash -c "mysql -u$(MYSQL_USER) -p$(MYSQL_PASS) -e $(CMD_SQL_LOGS_OFF)"

