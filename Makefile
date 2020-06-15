
extract-arb:
	flutter pub run intl_translation:extract_to_arb --output-dir=lib\l10n lib\zephyr_localization.dart

generate-intl:
	flutter pub run intl_translation:generate_from_arb --output-dir=lib\l10n --no-use-deferred-loading lib\zephyr_localization.dart lib\l10n\intl_en.arb lib\l10n\intl_fr.arb
