defmodule Paradise.AstronautDynamicSupervisors do
  @moduledoc """
  DynamicSupervisor helper functions
  """

  @spec start_child(Supervisor.child_spec()) :: Supervisor.on_start_child()
  def start_child(child_spec) do
    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {__MODULE__, self()}},
      child_spec
    )
  end

  @spec terminate_child(pid()) :: :ok | {:error, :not_found}
  def terminate_child(pid) do
    DynamicSupervisor.terminate_child(
      {:via, PartitionSupervisor, {__MODULE__, self()}},
      pid
    )
  end
end
