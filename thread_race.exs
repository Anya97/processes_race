defmodule ThreadRace do

  def add_nums(parent, a, b) do
    result = a+b
    :timer.sleep(a * 1000)
    send(parent, {:finished, result})
  end
end

parent = self()
a = spawn(fn -> ThreadRace.add_nums(parent, 1, 2) end)
b = spawn(fn -> ThreadRace.add_nums(parent, 2, 3) end)
c = spawn(fn -> ThreadRace.add_nums(parent, 2, 4) end)
d = spawn(fn -> ThreadRace.add_nums(parent, 2, 5) end)

processes = [a,b,c,d]

receive do
  {:finished, result} ->
    IO.inspect(result)
    Enum.each(processes, fn pid -> Process.exit(pid, :kill) end)
end

Enum.each(processes, fn pid ->
  IO.inspect(pid)
  IO.inspect(Process.alive?(pid))
end)
