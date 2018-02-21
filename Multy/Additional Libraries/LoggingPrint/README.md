# LoggingPrint

Swift convenience functions for outputting to the console only when the build setting for "Active  Complilation
Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`

Two methods are provided.

- `loggingPrint()` stands in for the `print()` function.
- `loggingDump()` stands in for the `dump()` function.

For `loggingPrint()` the textual representation is obtained from the `object` using `String(reflecting:)` which works for _any_ type. To
provide a custom format for the output make your object conform to `CustomDebugStringConvertible` and provide your
format in the `debugDescription` parameter.

For `loggingDump()` pass in the value to be dumped, and an optional string to act as a label that describes what is
being dumped

Through the magic of default function parameter values, the output for each function contains:

- Whether the call is being made on the UI or a background thread.
- The name of the file.
- The name of the function
- The line number where the print statement is located.

## Requirements

The latest version requires Swift 3.x and Xcode 8.

## Usage

The same way as you would use a `print()` statement, or a `dump()` statement.

## Installation

Just add the file to your project, and define `DEBUG` in your project's _Active Complilation Conditions_ setting.

*OR* if you are using Carthage add this to your Cartfile

``` shell

github "JungleCandy/LoggingPrint" >= 2.0

```

then drag the `LoggingPrint.swift` file out of the Checkouts folder and into your project.



