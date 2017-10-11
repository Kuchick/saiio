require 'pry'

INF = Float::INFINITY

def dijkstra(graph, source)

  dist = []
  prev = []
  visited = []
  unvisited = []

  dist[source] = 0

  graph.each_index do |i|
    if i != source
      dist[i] = INF
      prev[i] = nil
    end
    unvisited << i
  end

  current = source

  while unvisited or current
    unvisited.delete current
    visited << current
    arr = graph[current]

    nears = arr.select { |x| x > 0 }
    neighbors = nears.map { |x| arr.index x }

    neighbors.each do |v|
      alt = dist[current] + graph[current][v]
       if alt < dist[v]
        dist[v] = alt
        # prev[v] = dist[current]
        prev[v] = current
      end
    end

    temp = dist.select { |x| !visited.include? (dist.index(x)) }

    min = temp.min
    current = dist.index min

    unvisited = nil unless current
    current = nil unless unvisited
  end
  [dist, prev]
end

def shortest_path(graph, start, finish)
  dj_arr = dijkstra(graph, start)

  dist = dj_arr[0]
  prev = dj_arr[1]

  stack = []
  while prev[finish]
    # binding.pry
    stack << finish
    finish = prev[finish]
  end

  stack << start
  puts dist.to_s + ' dist to each node from source'
  puts prev.to_s + ' previous node to each node'
  puts stack.reverse.to_s + ' shortest path from start to finish'
end

file = open('dijkstra.txt', 'r')
start, finish = file.readline.chomp.split(',').map(&:to_i)
graph = []
file.each_line do |line|
  graph << line.split(",").map(&:to_i)
end

shortest_path(graph, start, finish)