import os
import shutil

# Source English ARB file
source_file = 'lib/src/l10n/app_en.arb'

# List of locales to generate (approx 100+)
locales = [
    'af', 'am', 'ar', 'as', 'az', 'be', 'bg', 'bn', 'bs', 'ca', 'cs', 'cy', 'da', 
    'el', 'et', 'eu', 'fa', 'fi', 'fil', 'gl', 'gu', 'he', 'hi', 'hr', 'hu', 
    'hy', 'id', 'is', 'it', 'ja', 'ka', 'kk', 'km', 'kn', 'ko', 'ky', 'lo', 
    'lt', 'lv', 'mk', 'ml', 'mn', 'mr', 'ms', 'my', 'nb', 'ne', 'nl', 'no', 
    'or', 'pa', 'pl', 'pt', 'ro', 'ru', 'si', 'sk', 'sl', 'sq', 'sr', 'sv', 
    'sw', 'ta', 'te', 'th', 'tl', 'tr', 'uk', 'ur', 'uz', 'vi', 'zu',
    # Adding more to reach 100+
    'af_ZA', 'am_ET', 'ar_AE', 'ar_BH', 'ar_DZ', 'ar_EG', 'ar_IQ', 'ar_JO', 
    'ar_KW', 'ar_LB', 'ar_LY', 'ar_MA', 'ar_OM', 'ar_QA', 'ar_SA', 'ar_SD', 
    'ar_SY', 'ar_TN', 'ar_YE', 'az_AZ', 'be_BY', 'bg_BG', 'bn_BD', 'bs_BA', 
    'ca_ES', 'cs_CZ', 'da_DK', 'de_AT', 'de_CH', 'el_GR', 'en_AU', 'en_CA', 
    'en_GB', 'en_IE', 'en_IN', 'en_NZ', 'en_SG', 'en_ZA', 'es_419', 'es_AR', 
    'es_BO', 'es_CL', 'es_CO', 'es_CR', 'es_DO', 'es_EC', 'es_GT', 'es_HN', 
    'es_MX', 'es_NI', 'es_PA', 'es_PE', 'es_PR', 'es_PY', 'es_SV', 'es_US', 
    'es_UY', 'es_VE', 'et_EE', 'fa_IR', 'fi_FI', 'fil_PH', 'fr_CA', 'fr_CH', 
    'gl_ES', 'gu_IN', 'he_IL', 'hi_IN', 'hr_HR', 'hu_HU', 'hy_AM', 'id_ID', 
    'is_IS', 'it_CH', 'ja_JP', 'ka_GE', 'kk_KZ', 'km_KH', 'kn_IN', 'ko_KR', 
    'ky_KG', 'lo_LA', 'lt_LT', 'lv_LV', 'mk_MK', 'ml_IN', 'mn_MN', 'mr_IN', 
    'ms_MY', 'my_MM', 'nb_NO', 'ne_NP', 'nl_BE', 'pa_IN', 'pl_PL', 'pt_BR', 
    'pt_PT', 'ro_RO', 'ru_RU', 'si_LK', 'sk_SK', 'sl_SI', 'sq_AL', 'sr_Cyrl', 
    'sr_Latn', 'sv_SE', 'sw_KE', 'ta_IN', 'te_IN', 'th_TH', 'tr_TR', 'uk_UA', 
    'ur_PK', 'uz_UZ', 'vi_VN', 'zh_CN', 'zh_HK', 'zh_TW', 'zu_ZA'
]

# Ensure the source file exists
if not os.path.exists(source_file):
    print(f"Error: Source file '{source_file}' not found.")
    exit(1)

# Read the content of the source file
with open(source_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Directory to save the generated files
output_dir = os.path.dirname(source_file)

count = 0
for locale in locales:
    filename = f'app_{locale}.arb'
    output_path = os.path.join(output_dir, filename)
    
    # Skip if file already exists to preserve manual translations (like hi, es, fr, de, zh)
    if os.path.exists(output_path):
        print(f"Skipping existing file: {filename}")
        continue

    # Modify the locale in the content (simplified approach)
    # This assumes the first line or so contains "@@locale": "en"
    # tailored replacement
    new_content = content.replace('"@@locale": "en"', f'"@@locale": "{locale}"')
    
    # Write the new file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Generated: {filename}")
    count += 1

print(f"\nTotal new files generated: {count}")
