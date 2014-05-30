# stackstudio-cookbook

Sets up [StackStudio](https://github.com/TranscendComputing/StackStudio) console.

## Supported Platforms

 - Ubuntu 12.04

## Attributes

- `node['stackstudio']['home']` - Defaults to '/home/stackstudio'
- `node['stackstudio']['git_revision']` - Defaults to 'master'
- `node['stackstudio']['cloudmux_endpoint']` - Defaults to 'http://localhost:9292'

## Usage

### stackstudio::default

By default, the console will come up on port 9001.

Include `stackstudio` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[stackstudio::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Transcend Computing. Inc. (<info@transcendcomputing.com>)
