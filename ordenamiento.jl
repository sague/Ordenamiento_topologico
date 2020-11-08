### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7b26536c-187b-11eb-082a-43cc3bf5236b
using LightGraphs, GraphPlot

# ╔═╡ 134bea26-188b-11eb-2d59-0fbbbbe59f2b
md"# Ordenamiento Topológico
Rocío Salinas Guerra"

# ╔═╡ d1889b56-187c-11eb-20aa-8187b1ceca79
md"""
## 

```julia
L ← Lista vacía que contendrá luego los elementos ordenados.
S ← Conjunto de todos los nodos sin aristas entrantes.

MIENTRAS [S no es vacío]:
	n ← nodo extraído de S
	insertar n en L

	PARA CADA [nodo m con arista e de n a m]:
		Eliminar arista e del grafo

		SI [m no tiene más aristas entrantes]:
			insertar m en S

SI [el grafo tiene más aristas]:
	error: el grafo tiene al menos un ciclo
SINO:
	RETORNAR L
```
Ref: https://en.wikipedia.org/wiki/Topological_sorting
"""

# ╔═╡ 358bddfa-1889-11eb-3edb-a9f36c3d9823
md"## Código en Julia"

# ╔═╡ d626c42c-187b-11eb-07ee-573ae1b1d728
# install dependencies
begin
	import Pkg
	Pkg.add("LightGraphs")
	Pkg.add("GraphPlot")
end

# ╔═╡ 405fbb14-1881-11eb-236e-912f623abc0d
function has_incoming_edge(node, G)

	for e in edges(G)
		if node == dst(e) #Devuelve el vértice del destino de la arista e
			return true
		end
	end
	
	false

end;

# ╔═╡ 19934180-187d-11eb-3338-156da0738ea8
function topological_sort(G)
	G = copy(G)
	L = Int[]
	S = findall(map( node -> !has_incoming_edge(node, G) , 1:nv(G) ))

	while !isempty(S)
		n = pop!(S)
		push!(L, n)
		
		# aristas de n a m
		the_edges = []
		for edge in edges(G)
			#Devuelve el vértice de origen de la arista e
			src(edge) == n && push!(the_edges, edge)			
		end
		
		for edge in the_edges
			# Devuelve el vértice destino de la arista e
			m = dst(edge)
			rem_edge!(G, edge)
			!has_incoming_edge(m, G) && push!(S, m)
			
		end
	end
	
	if ne(G) != 0
		error("la gráfica tiene al menos un ciclo")
		return gplot(G, nodelabel=1:nv(G))
	end
	
	return L
end

# ╔═╡ 48878296-188a-11eb-322c-c7a5a2d595b7
md"# Prueba"

# ╔═╡ c80b9e7a-188b-11eb-36d8-ed6f8189f3b3
# Matriz de Adyacencia (10 vértices, DAG)
B = Bool[
0 1 1 1 0 0 0 1 0 1
0 0 1 0 0 0 0 0 0 0
0 0 0 0 1 1 0 0 0 0
0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 1 0 0 0
0 0 0 0 1 0 1 0 0 0
0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
];

# ╔═╡ 523f5742-18d9-11eb-1943-f962a95f6094
#Matriz de Adyacencia (10 vértices con ciclos)
C = [
0 1 1 0 0 0 0 0 0 0
1 0 0 1 0 0 0 0 0 0
1 0 0 1 0 0 0 0 0 0
0 1 1 0 1 0 0 0 0 0
0 0 0 1 0 1 1 1 0 0
0 0 0 0 1 0 0 0 0 0
0 0 0 0 1 0 0 0 0 0
0 0 0 0 1 0 0 0 1 0
0 0 0 0 0 0 0 0 0 1
0 0 0 0 1 0 0 0 1 0	
];

# ╔═╡ 98b3d45a-187c-11eb-0003-0375fca375e9
G = SimpleDiGraph(B) # Genera la gráfica de la matriz de Ady.

# ╔═╡ a66ade8e-187c-11eb-1678-65ddeafb95f3
gplot(G, nodelabel=1:nv(G))

# ╔═╡ 5d8ff9a8-1889-11eb-29a0-4dada560864f
L = topological_sort(G)

# ╔═╡ 84e3f8ee-1931-11eb-3a39-873bbae134b8
md"#### Orden Topológico: $(join(L, \", \"))"

# ╔═╡ a8703232-1931-11eb-1b8e-cfacfe4b17fe
#Función julia de ordenamiento topológico para probar nuestro resultado
topological_sort_by_dfs(G)

# ╔═╡ 093bb2f8-18d3-11eb-0cbe-97818bbca9af
md"## Aplicación"

# ╔═╡ ae1a3ff0-18d9-11eb-3fc6-b7653457d4b5
md"###### Ejemplo 1 Clase:"

# ╔═╡ f919a742-18da-11eb-1d17-5b2370a9ca96
Tarea1 =["a", "b", "c", "d", "e", "f", "g"]

# ╔═╡ f2017f3e-18da-11eb-127f-13166f63f410
# Matriz de Adyacencia ejemplo Clase (7 vértices):
A1 = Bool[
0 1 1 1 0 0 0
0 0 1 0 0 0 0
0 0 0 0 1 1 0
0 0 0 0 0 1 0
0 0 0 0 0 0 1
0 0 0 0 1 0 1
0 0 0 0 0 0 0];

# ╔═╡ d5c2ee7c-18d3-11eb-2d21-69f3671f2f2e
G2 = SimpleDiGraph(A1)

# ╔═╡ d3453a10-18d3-11eb-1a40-e91968492b3f
gplot(G2, nodelabel=Tarea1)

# ╔═╡ e0b6b75c-18d3-11eb-2c1d-5375bfa88751
order1 = topological_sort(G2)

# ╔═╡ 4a810baa-1932-11eb-2eed-1b1ae430033f
#Función julia de ordenamiento topológico
topological_sort_by_dfs(G2)

# ╔═╡ 5fa428fe-18d4-11eb-2a93-a5f8b5091153
# Unión de una matriz de cadenas en una sola cadena
tareas_ordenadas = join(Tarea1[order1], " ⟶ ");

# ╔═╡ 2bc6a3b6-18d4-11eb-36d2-350dbf5d20bb
md"Orden: **$tareas_ordenadas**"

# ╔═╡ 7320b71a-18db-11eb-17e3-0f6bf3e3505a
md"###### Ejemplo 2 Clase:"

# ╔═╡ 730c5d9c-18db-11eb-1a0b-6b314b1c8661
Tarea2=["Hacer diseño", "elaborar presupuesto", "contar recursos humanos", "comprar materiales"];

# ╔═╡ 9c5e7138-18d3-11eb-1c2b-09b3e3059f37
A2 = Bool[
	0 1 0 0
	0 0 1 1
	0 0 0 0
	0 0 0 0
];

# ╔═╡ 72d53556-18db-11eb-3926-b7ef9d097018
G3 = SimpleDiGraph(A2)

# ╔═╡ 72efe510-18db-11eb-0df6-e927fede3a67
gplot(G3, nodelabel=Tarea2)

# ╔═╡ 72b944b8-18db-11eb-0d43-7f2c032c733b
order2 = topological_sort(G3)

# ╔═╡ cc687934-18db-11eb-0903-11a0041fe07c
tareas_ordenadas1 = join(Tarea2[order2], " ⟶ ");

# ╔═╡ f732160c-18db-11eb-07d8-d9242b923bc4
md"Orden: **$tareas_ordenadas1**"

# ╔═╡ d59a07e6-1932-11eb-2ca7-592adab7b1c8
#Función julia de ordenamiento topológico
order4= topological_sort_by_dfs(G3)

# ╔═╡ 41a435e8-19f8-11eb-1f66-5f90236fc203
Tareas_odr=join(Tarea2[order4], " ⟶ " );

# ╔═╡ 6765a3a4-19f8-11eb-1288-a7fc18417f5d
md"Orden: **$Tareas_odr**"

# ╔═╡ Cell order:
# ╟─134bea26-188b-11eb-2d59-0fbbbbe59f2b
# ╟─d1889b56-187c-11eb-20aa-8187b1ceca79
# ╟─358bddfa-1889-11eb-3edb-a9f36c3d9823
# ╠═d626c42c-187b-11eb-07ee-573ae1b1d728
# ╠═7b26536c-187b-11eb-082a-43cc3bf5236b
# ╠═405fbb14-1881-11eb-236e-912f623abc0d
# ╠═19934180-187d-11eb-3338-156da0738ea8
# ╟─48878296-188a-11eb-322c-c7a5a2d595b7
# ╠═c80b9e7a-188b-11eb-36d8-ed6f8189f3b3
# ╠═523f5742-18d9-11eb-1943-f962a95f6094
# ╟─84e3f8ee-1931-11eb-3a39-873bbae134b8
# ╟─a66ade8e-187c-11eb-1678-65ddeafb95f3
# ╠═98b3d45a-187c-11eb-0003-0375fca375e9
# ╠═5d8ff9a8-1889-11eb-29a0-4dada560864f
# ╠═a8703232-1931-11eb-1b8e-cfacfe4b17fe
# ╟─093bb2f8-18d3-11eb-0cbe-97818bbca9af
# ╟─ae1a3ff0-18d9-11eb-3fc6-b7653457d4b5
# ╟─f919a742-18da-11eb-1d17-5b2370a9ca96
# ╠═d3453a10-18d3-11eb-1a40-e91968492b3f
# ╟─2bc6a3b6-18d4-11eb-36d2-350dbf5d20bb
# ╠═f2017f3e-18da-11eb-127f-13166f63f410
# ╠═d5c2ee7c-18d3-11eb-2d21-69f3671f2f2e
# ╠═e0b6b75c-18d3-11eb-2c1d-5375bfa88751
# ╠═4a810baa-1932-11eb-2eed-1b1ae430033f
# ╠═5fa428fe-18d4-11eb-2a93-a5f8b5091153
# ╟─7320b71a-18db-11eb-17e3-0f6bf3e3505a
# ╠═730c5d9c-18db-11eb-1a0b-6b314b1c8661
# ╟─72efe510-18db-11eb-0df6-e927fede3a67
# ╟─f732160c-18db-11eb-07d8-d9242b923bc4
# ╠═9c5e7138-18d3-11eb-1c2b-09b3e3059f37
# ╠═72d53556-18db-11eb-3926-b7ef9d097018
# ╠═72b944b8-18db-11eb-0d43-7f2c032c733b
# ╠═cc687934-18db-11eb-0903-11a0041fe07c
# ╠═d59a07e6-1932-11eb-2ca7-592adab7b1c8
# ╠═41a435e8-19f8-11eb-1f66-5f90236fc203
# ╟─6765a3a4-19f8-11eb-1288-a7fc18417f5d
