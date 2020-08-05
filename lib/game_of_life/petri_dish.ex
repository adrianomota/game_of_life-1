defprotocol GameOfLife.PetriDish do
  @spec active?(t, pos_integer, pos_integer) :: boolean
  def active?(petri_dish, x, y)

  @spec activate(t, pos_integer, pos_integer) :: t
  def activate(petri_dish, x, y)

  @spec deactivate(t, pos_integer, pos_integer) :: t
  def deactivate(petri_dish, x, y)

  @spec cells_to_analyze(t) :: [{pos_integer, pos_integer}]
  def cells_to_analyze(petri_dish)

  @spec active_neighbours(t, pos_integer, pos_integer) :: non_neg_integer
  def active_neighbours(petri_dish, x, y)

  @spec clean(t) :: t
  def clean(t) :: t
end
