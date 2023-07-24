# LbEcharts
Charting library using Echarts for Livebook

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lb_echarts` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lb_echarts, git: "https://github.com/parth-patil/lb_echarts.git"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/lb_echarts>.

## Usage Examples
### Bar Chart

```elixir
options = %{
  x: ["Shirts", "Cardigans", "Chiffons", "Pants", "Heels", "Socks"],
  y: [5, 20, 36, 10, 10, 20],
  title: "My exmaple chart",
  legend: ["sales", "input"]
}

LbEcharts.bar(options)
```

### Stacked Bar Chart
```elixir
get_rand_nums = fn quantity, start_range, end_range ->
  1..quantity
  |> Enum.map(fn _i ->
    start_range..end_range |> Enum.random()
  end)
end

stacked_bar_options = %{
  title: "My Stacked Bar Chart",
  legend: [
    "Email",
    "Union Ads",
    "Video Ads",
    "Direct",
    "Search Engine"
  ],
  categories: [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ],
  orientation: "horizontal", # Change to "vertical" for vertical orientation
  stacked_data: %{
    "Email" => get_rand_nums.(7, 200, 300),
    "Union Ads" => get_rand_nums.(7, 200, 300),
    "Video Ads" => get_rand_nums.(7, 100, 300),
    "Direct" => get_rand_nums.(7, 150, 300),
    "Search Engine" => get_rand_nums.(7, 200, 300)
  }
}

LbEcharts.stacked_bar(stacked_bar_options)
```

### Sankey Chart
```elixir
response = Req.get!("https://echarts.apache.org/examples/data/asset/data/product.json")
%{body: sankey_data} = response

sankey_opts = %{
  num_levels: 3,
  nodes: sankey_data["nodes"],
  links: sankey_data["links"]
}

LbEcharts.sankey(sankey_opts)
```