import json
import os

def sync_arb_files(source_file, target_dir):
    with open(source_file, 'r', encoding='utf-8') as f:
        source_data = json.load(f)
    
    source_keys = set(source_data.keys())
    
    for filename in os.listdir(target_dir):
        if filename.endswith('.arb') and filename != os.path.basename(source_file):
            target_path = os.path.join(target_dir, filename)
            with open(target_path, 'r', encoding='utf-8') as f:
                target_data = json.load(f)
            
            # Identify missing keys
            missing_keys = source_keys - set(target_data.keys())
            
            if missing_keys:
                print(f"Syncing {filename}: Adding {len(missing_keys)} missing keys.")
                for key in missing_keys:
                    target_data[key] = source_data[key]
                
                # Sort alphabetically by key (optional, but good for consistency)
                # Note: @@locale and @tags should ideally be handled specifically if order matters
                sorted_data = {k: target_data[k] for k in sorted(target_data.keys())}
                # Ensure @@locale stays at the top if it exists
                if '@@locale' in sorted_data:
                    locale_val = sorted_data.pop('@@locale')
                    sorted_data = {'@@locale': locale_val, **sorted_data}
                
                with open(target_path, 'w', encoding='utf-8') as f:
                    json.dump(sorted_data, f, ensure_ascii=False, indent=2)
            else:
                print(f"{filename} is already in sync.")

if __name__ == "__main__":
    source = r"c:\Users\techn\StudioProjects\CopyClip\lib\src\l10n\app_en.arb"
    target_dir = r"c:\Users\techn\StudioProjects\CopyClip\lib\src\l10n"
    sync_arb_files(source, target_dir)
