require 'pry'
require 'set'

def bellman(graph, start, finish)
  start -= 1
  finish -= 1
  prev = []
  b = []
  i_star = [start]
  prev[start] = 0
  b[start] = 0

  current = start
  entries = []
  while b[finish].nil?
    pathes = all_pathes(graph, i_star)
    # where we can go from current node - w(I*)
    next_node = pathes.find { |index| (existing_indexes(graph.transpose[index]) - i_star).empty? && b[index].nil? }
    # find node for which I(-, j*) in I*
    prev[next_node] = current
    b[next_node] = calc_max_length(graph, b, next_node, i_star)
    current = next_node
    i_star << next_node
    i_star.uniq
  end
  puts "b = #{b}"
  puts "f = #{prev}"
end

def all_pathes(graph, i_star)
  i_star.inject([]) { |accum, index| accum + existing_indexes(graph[index])}.uniq
end

def existing_indexes(array)
  array.map.with_index { |elem, index| index if elem }.compact
end

def calc_max_length(graph, b, current, indexes)
  indexes.map do |index|
    next unless graph.transpose[current][index]
    b[index] + graph.transpose[current][index]
  end.compact.max
end

def entries_for_node(graph, current_index, i_star)
  i_star.select { |i| existing_indexes(graph[current_index]).include? i }
end

file = open('bellman.txt', 'r')
start, finish = file.readline.chomp.split(',').map(&:to_i)
graph = []
file.each_line do |line|
  graph << line.split(",").map(&:to_i).map{ |x| x.zero? ? nil : x}
end
file.close

bellman(graph, start, finish)
