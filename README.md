# BrainFudge

Simple interpreter for the esoteric BF programming language written in Haskell.

## Compilation

If you have the static GHC libaries, simply run:
```
ghc Main.hs -o BrainFudge
```

Otherwise; if you have the dynamic GHC libaries:
```
ghc -dynamic Main.hs -o BrainFudge
```

Feel free to add `-O3` flag for better performance.

## Usage

You can either give a filepath as an argument
```
./BrainFudge file.b
```

Or simply feed the file contents directly into standard input.

```
./BrainFudge < file.b
```

Feel free to test out Hello, World.

```
echo "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++." | ./BrainFudge 
```

## Caveats/Unfinished features

The `,` operator which reads standard input is buffered and expects a return key.
This will be fixed if I bother figuring out how to get raw mode working in Haskell.

