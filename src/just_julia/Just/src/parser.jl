"""
parses the lexers output into abstract syntaxt tree for the Just language
"""

using DataFrames, DataFramesMeta
import Graphs

ast = Graphs.DiGraph()

Graphs.add_vertex!(ast)

token_df = filter(row -> !(row.type in ["comment", "new_line"]), token_df)

Graphs.add_edge!(ast, 3, 4) 