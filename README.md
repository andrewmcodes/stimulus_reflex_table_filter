# README

## StimulusReflex

Make sure you checkout [StimulusReflex](https://github.com/hopsoft/stimulus_reflex) for more information on how this awesomeness was achieved.

You can find documentation on the project [here](https://docs.stimulusreflex.com). If you run into trouble, reach out to me on [Twitter](https://twitter.com/andrewmcodes) and I will try to help!

## Setup instructions

1. Dependencies

Make sure you have ruby, node, and postgres installed and running.

Here is what I am using:

```
➜ rbenv -v
rbenv 1.1.2

➜ ruby -v
ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]

➜ nvm --version
0.35.0

➜ node -v
v12.11.1

➜ postgres --version
postgres (PostgreSQL) 11.5
```

2. Clone the repo

```
git clone https://github.com/andrewmcodes/stimulus_reflex_table_filter
cd stimulus_reflex_table_filter
```

3. `bundle install && yarn`

4. `rails db:create db:migrate db:seed`

5. `rails s`

6. Go to `localhost:3000` and see the magic.

7. Feel free to experiment and submit pull requests!

## Tutorial

This is still a work in progress, but the tutorial to create this can be found [here](TUTORIAL.md).

## Contributing

### Code of Conduct

Everyone interacting with StimulusReflex is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md)

### Coding Standards

This project uses [Standard](https://github.com/testdouble/standard) to minimize bike shedding related to code formatting.

Please run `bundle exec standardrb --fix` prior submitting pull requests.

### Contributing Guide

[Contributing Guide](/CONTRIBUTING.md)

## License

[MIT](/LICENSE.md)
