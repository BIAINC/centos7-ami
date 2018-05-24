# cis_benchmark-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cis_benchmark']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cis_benchmark::default

Include `cis_benchmark` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cis_benchmark::default]"
  ]
}
```

## License and Authors

Author:: Paul Morton (<pmorton@biaprotect.com>)
