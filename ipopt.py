# Imports
from coopr.pyomo import *
# ***********************************
model = AbstractModel()
# ***********************************
model.datos = Set()
# ***********************************
model.MIN = Param(model.datos, within=NonNegativeReals)
model.MAX = Param(model.datos, within=NonNegativeReals)
model.A = Param(model.datos, within=NonNegativeReals)
model.B = Param(model.datos, within=NonNegativeReals)
model.Presupuesto = Param(within=NonNegativeReals)
# ***********************************
def Level_bounds(model, i):
  return (model.MIN[i], model.MAX[i])
model.x = Var(model.datos, bounds=Level_bounds)
# ***********************************
def Total_Cost_rule(model):
  return sum([exp(model.A[j]-model.B[j]/model.x[j]) \
              for j in model.datos])

model.Total_Cost = Objective(rule=Total_Cost_rule,sense=maximize)
# ***********************************
def Demand_rule(model):
  return sum([model.x[i] for i in model.datos]) <= model.Presupuesto

model.Demand = Constraint(rule=Demand_rule)