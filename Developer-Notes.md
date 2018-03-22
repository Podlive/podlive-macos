# Podlive for macOS
### Developer Notes

This project uses parts of [libextobjc](https://github.com/jspahrsummers/libextobjc) by Justin Spahr-Summers to handle `weak` and `strong` references in blocks. Additional, there is nothing special, but a few and simple rules based on Swift syntax:

#### 1. Type Inference

*When it’s possible*, we make use of two tiny but elegant macros:

```Objective-C
#define var __auto_type
#define let const __auto_type
```

Instead of using:

```Objective-C
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
```

you should use:

```Objective-C
let defaults = [NSUserDefaults standardUserDefaults];
```

#### 2. Allways use dot notation

Keeping the example above in mind, instead of:

```Objective-C
let defaults = [NSUserDefaults standardUserDefaults];
```

you should use:

```Objective-C
let defaults = NSUserDefaults.standardUserDefaults;
```

#### 3. Indentation

The project uses `4 spaces`.

#### 4. No Interface-Builder

This project uses absolutely no (ok, nearly) XIB’s and no Storyboards. The entire UI is prototyped in code. This gives you clarity on what is happening behind the scenes, you avoid mind boggling merge conflicts and last but not least it results in a better sleep at night. It’s that simple! 😉