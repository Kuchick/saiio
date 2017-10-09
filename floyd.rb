require 'pry'
def floyd_warshall(n, edges)
  weight_matrix = Array.new(n) { |i| Array.new(n) { |j| i == j ? 0 : Float::INFINITY } }
  ancestors_matrix = Array.new(n) { Array.new(n) }
  edges.each do |u,v,w|
    weight_matrix[u-1][v-1] = w
    ancestors_matrix[u-1][v-1] = v - 1
  end
 
  n.times do |k|
    n.times do |i|
      n.times do |j|
        if weight_matrix[i][j] > weight_matrix[i][k] + weight_matrix[k][j]
          weight_matrix[i][j] = weight_matrix[i][k] + weight_matrix[k][j]
          ancestors_matrix[i][j] = ancestors_matrix[i][k]
        end
      end
    end
  end
 
  puts "pair     weight_matrix    path"
  n.times do |i|
    n.times do |j|
      next if i == j
      u = i
      path = [u]
      path << (u = ancestors_matrix[u][j])  while u != j
      path = path.map { |u| u+1 }.join(" -> ")
      puts "%d -> %d  %4d     %s" % [i+1, j+1, weight_matrix[i][j], path]
    end
  end
end

file = open('floyd.txt', 'r')
edges = []
file.lines do |line|
  edges << line.split(",").map(&:to_i)
end
n = edges.inject([]) { |acc, arr| acc << arr[0] << arr[1] }.uniq.count
floyd_warshall(n, edges)