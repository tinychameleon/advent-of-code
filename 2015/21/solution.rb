require './utils'

class Solution
  TEST_SHOP = {
    weapons: [1, 2],
    armor: [1, 2, 3],
    rings: [1, 2, 3, 4]
  }.freeze

  TEST_GEAR = [
    { cost: 1, damage: 2, armor: 0 },
    { cost: 3, damage: 0, armor: 1 },
    { cost: 0, damage: 0, armor: 0 },
    { cost: 4, damage: 1, armor: 0 }
  ].freeze

  def tests
    player = { hp: 8, damage: 5, armor: 5 }
    boss = { hp: 11, damage: 7, armor: 2 }
    rigged = { hp: 99, damage: 10, armor: 10 }

    assert turns_to_kill(boss, player), 4
    assert turns_to_kill(player, boss), 4

    assert fight_victor(player, boss), :player
    assert fight_victor(player, rigged), :boss

    assert item_combinations(**TEST_SHOP).count, 42

    cost, player = suit_up(TEST_GEAR)
    assert cost, 8
    assert player[:hp], 100
    assert player[:damage], 3
    assert player[:armor], 1
    :ok
  end

  def part_a
    solve_a
  end

  def part_b
    solve_b
  end

  private

  PLAYER_HP = 100
  BOSS = { hp: 103, damage: 9, armor: 2 }.freeze

  SHOP = {
    weapons: [
      { cost: 8, damage: 4, armor: 0 },
      { cost: 10, damage: 5, armor: 0 },
      { cost: 25, damage: 6, armor: 0 },
      { cost: 40, damage: 7, armor: 0 },
      { cost: 74, damage: 8, armor: 0 }
    ],
    armor: [
      { cost: 0, damage: 0, armor: 0 },
      { cost: 13, damage: 0, armor: 1 },
      { cost: 31, damage: 0, armor: 2 },
      { cost: 53, damage: 0, armor: 3 },
      { cost: 75, damage: 0, armor: 4 },
      { cost: 102, damage: 0, armor: 5 }
    ],
    rings: [
      { cost: 0, damage: 0, armor: 0 },
      { cost: 25, damage: 1, armor: 0 },
      { cost: 50, damage: 2, armor: 0 },
      { cost: 100, damage: 3, armor: 0 },
      { cost: 20, damage: 0, armor: 1 },
      { cost: 40, damage: 0, armor: 2 },
      { cost: 80, damage: 0, armor: 3 }
    ]
  }.freeze

  def turns_to_kill(attacker, target)
    target[:hp].fdiv([1, attacker[:damage] - target[:armor]].max).ceil
  end

  def fight_victor(player, boss)
    turns_to_kill(player, boss) <= turns_to_kill(boss, player) ? :player : :boss
  end

  def item_combinations(weapons:, armor:, rings:)
    no_ring = rings[0]
    ring_choices = [[no_ring, no_ring]].chain(rings.combination(2)).to_a
    weapons.product(armor).product(ring_choices).map(&:flatten)
  end

  def sum_stat(gear, stat)
    gear.reduce(0) { |sum, item| sum + item[stat] }
  end

  def suit_up(gear)
    cost = sum_stat(gear, :cost)
    damage = sum_stat(gear, :damage)
    armor = sum_stat(gear, :armor)
    player = { hp: PLAYER_HP, damage: damage, armor: armor }
    [cost, player]
  end

  def solve(winner)
    item_combinations(**SHOP)
      .map { |gear| suit_up(gear) }
      .filter { |_cost, player| fight_victor(player, BOSS) == winner }
      .map(&:first)
  end

  def solve_a
    solve(:player).min
  end

  def solve_b
    solve(:boss).max
  end
end
