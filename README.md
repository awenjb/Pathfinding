#  Projet d'informatique scientifique L3 Math-Info 2022-2023

# Description
Implémentation des algorithmes de Dijkstra et A*
Application des algorithmes sur des fichiers .map
Utilisation des packages julia suivant : DataStructures, Gtk, Graphics

#  Instruction

pour tester un fichier .map
- déposer le fichier .map dans le dossier map

via le REPL de julia
- accéder au dossier contenant le projet
- using("AStar.jl")
- using("dijkstra.jl")

Exemple d'utilisation des deux algoritmes pour un chemin allant de (1,1) à (8,7) sur un fichier "test.map"
- algoAStar("test.map", (1,1), (8,7))
- algoDijkstra("test.map", (1,1), (8,7))
