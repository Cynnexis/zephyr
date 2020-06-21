DCK_CMP_UP=docker-compose up --remove-orphans

.PHONY: all test

docker-build:
	docker build -t cynnexis/zephyr .

docker-test:
	$(DCK_CMP_UP) test

docker-down:
	docker-compose down --remove-orphans --volumes

docker-kill:
	docker rm -f $$(docker ps -aq) || docker rmi -f $$(docker images -f "dangling=true" -q) || docker system prune -f

extract-arb:
	flutter pub run intl_translation:extract_to_arb --output-dir=lib\l10n lib\zephyr_localization.dart

generate-intl:
	flutter pub run intl_translation:generate_from_arb --output-dir=lib\l10n --no-use-deferred-loading lib\zephyr_localization.dart lib\l10n\intl_en.arb lib\l10n\intl_fr.arb lib\l10n\intl_es.arb

update-launcher:
	flutter pub run flutter_launcher_icons:main

lint:
	dartfmt -n --set-exit-if-changed -l 120 .

fix-lint:
	dartfmt -w -l 120 .

test:
	flutter test --coverage test/*_test.dart

test-integration:
	flutter drive --target=test_driver/search.dart
