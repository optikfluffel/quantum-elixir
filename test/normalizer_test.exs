defmodule Quantum.NormalizerTest do
  use ExUnit.Case

  import Quantum.Normalizer

  # test "normalize" do
  #   assert normalize({"0", nil}) == {"0", nil}
  #   assert normalize({"A", nil}) == {"a", nil}
  #   assert normalize({"jan", nil}) == {"1", nil}
  #   assert normalize({:atom, nil}) == {"atom", nil}
  #   assert normalize("* * * * * MyApp.MyModule.my_method") == {"* * * * *", {"MyApp.MyModule", :my_method}}
  # end

  test "named job" do
    job = {:newsletter, [
      schedule: "@weekly",
      task: "MyModule.my_method",
      args: [1, 2, 3],
      nodes: [:atom@node, "string@node"]
    ]}

    assert normalize(job) == {:newsletter, %Quantum.Job{
      name: :newsletter,
      schedule: "@weekly",
      task: {"MyModule", "my_method"},
      args: [1, 2, 3],
      nodes: [:atom@node, :string@node]
    }}
  end

  test "unnamed job as string" do
    job = "* * * * * MyModule.my_method"

    assert normalize(job) == {nil, %Quantum.Job{
      name: nil,
      schedule: "* * * * *",
      task: {"MyModule", "my_method"},
      args: []
    }}
  end

  test "unnamed job as tuple" do
    job = {"* * * * *", "MyModule.my_method"}

    assert normalize(job) == {nil, %Quantum.Job{
      name: nil,
      schedule: "* * * * *",
      task: {"MyModule", "my_method"},
      args: []
    }}
  end

  test "unnamed job as tuple with arguments" do
    job = {"* * * * *", {"MyModule", "my_method", [1, 2, 3]}}

    assert normalize(job) == {nil, %Quantum.Job{
      name: nil,
      schedule: "* * * * *",
      task: {"MyModule", "my_method"},
      args: [1, 2, 3]
    }}
  end

  test "cron-like unnamed job" do
    job = "@weekly MyModule.my_method"

    assert normalize(job) == {nil, %Quantum.Job{
      name: nil,
      schedule: "@weekly",
      task: {"MyModule", "my_method"},
      args: []
    }}
  end

end
