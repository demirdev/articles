# Stop Typing Long Commands: Why Flutter Projects Need Script Files

## Problem

Commands we use in Flutter and Dart applications can be quite long. For example:

```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
dart run build_runner build --delete-conflicting-outputs
flutter build appbundle --release --flavor production
```

Searching for these commands in terminal history or rewriting them every time means wasting our time. Additionally, we cannot expect new developers joining the project to know all build commands.

## Solution

There are two methods to simplify these commands:
1. **Creating script files** (covered in this article)
2. **Defining aliases** (shell configuration)

In this article, we will see how to shorten commands by creating script files in a Flutter project.

## Step 1: Create Scripts Directory

Create a folder named `scripts` in your Flutter project's root directory:

```bash
mkdir scripts
```

## Step 2: Create Script Files

Create the shell files you need inside the `scripts` directory. Give each file a `.sh` extension. It is very important to create your own scripts according to your project's needs.

### build_runner.sh

```bash
#!/bin/bash
dart run build_runner build --delete-conflicting-outputs
```

### build_ipa.sh

```bash
#!/bin/bash
flutter build ipa
```

### build_appbundle.sh

```bash
#!/bin/bash
flutter build appbundle
```

## Step 3: Grant Execution Permission

You must grant execution permission to the script files you created:

```bash
chmod u+x scripts/build_runner.sh
chmod u+x scripts/build_ipa.sh
chmod u+x scripts/build_appbundle.sh
```

Or to grant permission to all scripts at once:

```bash
chmod u+x scripts/*.sh
```

## Step 4: Using Scripts

Now you can easily run these scripts from your Flutter project's root directory:

```bash
./scripts/build_runner.sh
./scripts/build_ipa.sh
./scripts/build_appbundle.sh
```

## Why Should We Use Script Files?

1. **Time Saving**: You run scripts with short names instead of typing long commands
2. **Standardization**: The entire team uses the same commands, no inconsistency
3. **Documentation**: Scripts show what build commands the project has
4. **Ease for New Developers**: Someone new to the project can see what they can do by looking at the `scripts/` folder, even without knowing the details
5. **Flexibility**: You can add additional parameters, conditions, or cleanup operations to scripts

## Example Project Structure

```
my_flutter_project/
├── lib/
├── test/
├── android/
├── ios/
├── scripts/
│   ├── build_runner.sh
│   ├── build_ipa.sh
│   ├── build_appbundle.sh
│   ├── build_ios.sh
│   ├── clean_build.sh
│   └── run_tests.sh
├── pubspec.yaml
└── README.md
```

## Conclusion

It is important that every Flutter/Dart project has project-specific scripts. This way, any developer looking at the project can perform production builds or other operations by running files in the `scripts/` directory, even without knowing the details.
