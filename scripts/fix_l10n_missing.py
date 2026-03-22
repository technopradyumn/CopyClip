import json
import glob
import os

l10n_dir = 'lib/src/l10n'
template_path = os.path.join(l10n_dir, 'app_en.arb')
with open(template_path, 'r', encoding='utf-8') as f:
    template = json.load(f)

missing_keys = {
    'textCopiedToClipboardFacebook',
    'orderingOnlyAvailableInAllPosts',
    'startSocialJourney',
    'moodHappy',
    'deletedItemsAppearHere',
    'bulkImport',
    'dataExport',
    'unlockPermanently',
    'whatIsThisFor',
}

updated_count = 0

for path in glob.glob(os.path.join(l10n_dir, 'app_*.arb')):
    if os.path.basename(path) == 'app_en.arb':
        continue
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    changed = False
    for key in missing_keys:
        if key not in data and key in template:
            data[key] = template[key]
            changed = True

    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2, sort_keys=True)
        updated_count += 1
        print('Updated', path)

print('Done', updated_count, 'files updated')
