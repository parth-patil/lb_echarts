defmodule LbEcharts do
  use Kino.JS

  def new(chart_data) do
    Kino.JS.new(__MODULE__, chart_data)
  end

  def bar(opts) do
    options =
      %{
        "title" => %{"text" => opts.title},
        "tooltip" => %{},
        "legend" => %{"data" => opts.legend},
        "xAxis" => %{"data" => opts.x},
        "yAxis" => %{},
        "series" => [
          %{
            "name" => "sales",
            "type" => "bar",
            "data" => opts.y
          }
        ]
      }
      |> Jason.encode!()

    LbEcharts.new(options)
  end

  def stacked_bar(opts) do
    options = %{
      "title" => %{"text" => opts.title},
      "tooltip" => %{
        "trigger" => "axis",
        "axisPointer" => %{"type" => "shadow"}
      },
      "grid" => %{"left" => "3%", "right" => "4%", "bottom" => "3%", "containLabel" => true},
      "toolbox" => %{"feature" => %{"saveAsImage" => %{}}}
    }

    category_opts = %{"type" => "category", "boundaryGap" => true, "data" => opts.categories}
    value_opts = %{"type" => "value"}

    [x_axis, y_axis] =
      case opts[:orientation] do
        "vertical" -> [category_opts, value_opts]
        "horizontal" -> [value_opts, category_opts]
        # default is vertically stacked
        _ -> [category_opts, value_opts]
      end

    series_attrs = %{
      "type" => "bar",
      "stack" => "Total",
      "label" => %{"show" => true},
      "emphasis" => %{"focus" => "series"}
    }

    series =
      opts.stacked_data
      |> Enum.map(fn {k, v} ->
        Map.merge(series_attrs, %{"name" => k, "data" => v})
      end)

    json_options =
      options
      |> Map.put("series", series)
      |> Map.put("xAxis", x_axis)
      |> Map.put("yAxis", y_axis)
      |> Jason.encode!()

    LbEcharts.new(json_options)
  end

  defp rand_hex_color() do
    0..5
    |> Enum.map(fn _i ->
      0..15 |> Enum.random() |> Integer.to_string(16)
    end)
    |> Enum.join()
  end

  def sankey(%{num_levels: num_levels, nodes: nodes, links: links}) do
    base_options = %{
      "title" => %{
        "text" => "Sankey Diagram"
      },
      "tooltip" => %{
        "trigger" => "item",
        "triggerOn" => "mousemove"
      },
      "series" => []
    }

    series_base_options = %{
      "type" => "sankey",
      "emphasis" => %{"focus" => "adjacency"},
      "lineStyle" => %{"curveness" => 0.5},
      "data" => [],
      "links" => []
    }

    series_levels =
      0..num_levels
      |> Enum.map(fn level ->
        %{
          "depth" => level,
          "itemStyle" => %{"color" => "#" <> rand_hex_color()},
          "lineStyle" => %{"color" => "source", "opacity" => 0.6}
        }
      end)

    series_opts =
      series_base_options
      |> Map.put("levels", series_levels)
      |> Map.put("data", nodes)
      |> Map.put("links", links)

    json_opts =
      base_options
      |> Map.put("series", [series_opts])
      |> Jason.encode!()

    LbEcharts.new(json_opts)
  end

  asset "main.js" do
    """
    export async function init(ctx, chart_data) {
      await ctx.importJS("https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js");

      ctx.root.innerHTML = `
        <div id="echart_window" style="width: 800px;height:500px;"></div>`

        var myChart = echarts.init(document.getElementById('echart_window'));

        // Specify the configuration items and data for the chart
        var options = JSON.parse(chart_data);

        // Display the chart using the configuration items and data just specified.
        myChart.setOption(options);
    }
    """
  end
end
