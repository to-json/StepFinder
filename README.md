## Synopsis

This launches a local web server that indexes your cucumber steps and
provides a search tool.

## Motivation

Finding step definitions sucks. Predicting what transforms will be
applied to the step you're writing sucks *a lot*. I hope to
mitigate a portion of that pain.

## The fuuuuuutuuuuurreeee

I see a local socket server, a Sublime plugin, a vim plugin, and an emacs
plugin, in that order. Maybe I'll slide Atom in there somewhere, if my
team starts using it. Alternately, maybe it will languish, if my team
stops using Cucumber. Predictions are hard.

Also maybe I should support step definitions that aren't in ruby. Does
anyone actually do that? Right now they'll be ignored outright.

## Installation

Clone the repository, edit the file 'location' to contain a path to
your cucumber repository, and then run ./main.rb in the repo directory.
Once it's running, point a decent browser at http://localhost:4567 .

It's worth noting that if your tests don't currently execute, neither
will the tool. That means, if for some strange reason, your env.rb requires
an external system to be up (<.<), so does this tool. I started to write my own
step definition parser, and have not wholly abandoned that work, but man,
it was getting super painful and it's a small price to ask that your tests
work before you set up the search tool; if they don't, finding a step is the
least of your worries, non?

### It's broken on IE8!

I said a decent browser. Wont fix. Will intentionally reject PRs to fix.

## Usage

The search box works as you might expect. The 'search' button looks at
the words in the regex for the step, which is to say that given the query

    "user Phil"

it would find the step

    /^The user Phil logs in$/

but not the step

    /^The user "(.*)"$/

The match button asks the cucumber runtime "What step definition is found for
this sentence?" If transforms are applied, it indexes them as well, and returns
the whole shebang.

The first search after each launch will be slower as it's indexing the system 
at that point. Subsequent searches should be quite quick.

## Contributors

Probably you don't want to? Pull requests welcome, I 'spose, as are github 
issues. Alternately, contact me and we'll chat.

## Tests

<.<

Soon, I hope. I tested it with a project from my day job containing >1000
steps. It seems to work pretty well. Using line continuations after a step
like so:

  Given(/^I do the "thing"$/) /
  do |arg|

will prevent the parser from returning the source code of your step, but 
really, that's awful and you shouldn't do it.

## License

StepFinder Copyright (C) 2015 by Jason Saxon

StepFinder is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

### But why not MIT? I don't like viral licenses?

Because MIT is giving away the right to turn my work into a closed source
engine to empower a corporation. I just want to help testers. K?
