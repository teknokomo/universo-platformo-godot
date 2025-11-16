#!/bin/bash
# Validation script for Universo Platformo Godot
# This script checks that the project structure is correct

echo "=== Universo Platformo Godot - Project Validation ==="
echo

# Check Godot project file
if [ -f "project.godot" ]; then
    echo "✅ project.godot found"
else
    echo "❌ project.godot not found"
    exit 1
fi

# Check core directories
directories=("packages" "scenes" "scripts" "assets" "addons")
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ Directory $dir exists"
    else
        echo "❌ Directory $dir missing"
        exit 1
    fi
done

# Check autoload scripts
autoloads=("scripts/autoload/config.gd" "scripts/autoload/database_manager.gd" "scripts/autoload/network_manager.gd")
for script in "${autoloads[@]}"; do
    if [ -f "$script" ]; then
        echo "✅ Autoload $script exists"
    else
        echo "❌ Autoload $script missing"
        exit 1
    fi
done

# Check documentation files
docs=("README.md" "README-RU.md" "CONTRIBUTING.md" "CONTRIBUTING-RU.md" "ARCHITECTURE.md" "ARCHITECTURE-RU.md")
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "✅ Documentation $doc exists"
    else
        echo "❌ Documentation $doc missing"
        exit 1
    fi
done

# Check bilingual documentation line counts
echo
echo "=== Checking Bilingual Documentation ==="
readme_en=$(wc -l < README.md)
readme_ru=$(wc -l < README-RU.md)
diff_readme=$((readme_en - readme_ru))
if [ ${diff_readme#-} -le 2 ]; then
    echo "✅ README line counts are similar (EN: $readme_en, RU: $readme_ru)"
else
    echo "⚠️  README line counts differ significantly (EN: $readme_en, RU: $readme_ru)"
fi

contrib_en=$(wc -l < CONTRIBUTING.md)
contrib_ru=$(wc -l < CONTRIBUTING-RU.md)
diff_contrib=$((contrib_en - contrib_ru))
if [ ${diff_contrib#-} -le 2 ]; then
    echo "✅ CONTRIBUTING line counts match (EN: $contrib_en, RU: $contrib_ru)"
else
    echo "⚠️  CONTRIBUTING line counts differ (EN: $contrib_en, RU: $contrib_ru)"
fi

arch_en=$(wc -l < ARCHITECTURE.md)
arch_ru=$(wc -l < ARCHITECTURE-RU.md)
diff_arch=$((arch_en - arch_ru))
if [ ${diff_arch#-} -le 2 ]; then
    echo "✅ ARCHITECTURE line counts match (EN: $arch_en, RU: $arch_ru)"
else
    echo "⚠️  ARCHITECTURE line counts differ (EN: $arch_en, RU: $arch_ru)"
fi

# Check package structure
echo
echo "=== Checking Package Structure ==="
if [ -d "packages/clusters-frt/base" ]; then
    echo "✅ Clusters frontend package exists"
    if [ -f "packages/clusters-frt/base/plugin.cfg" ] && [ -f "packages/clusters-frt/base/plugin.gd" ]; then
        echo "✅ Clusters frontend plugin files exist"
    else
        echo "❌ Clusters frontend plugin files missing"
        exit 1
    fi
else
    echo "❌ Clusters frontend package missing"
    exit 1
fi

if [ -d "packages/clusters-srv/base" ]; then
    echo "✅ Clusters server package exists"
    if [ -f "packages/clusters-srv/base/plugin.cfg" ] && [ -f "packages/clusters-srv/base/plugin.gd" ]; then
        echo "✅ Clusters server plugin files exist"
    else
        echo "❌ Clusters server plugin files missing"
        exit 1
    fi
else
    echo "❌ Clusters server package missing"
    exit 1
fi

echo
echo "=== All Checks Passed! ==="
echo "✅ Repository structure is valid"
echo "✅ Core files are present"
echo "✅ Documentation is complete"
echo "✅ Package structure is correct"
echo
echo "Project is ready for development!"
