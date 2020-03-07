require './utils'

class Solution
  def tests
    assert next_spells([]), %i[magic_missile drain shield poison recharge]
    assert next_spells(%i[drain poison]),
           %i[magic_missile drain shield recharge]
    assert next_spells(%i[drain recharge poison shield]),
           %i[magic_missile drain recharge]

    assert mana_cost([]), 0
    assert mana_cost([:magic_missile]), 53
    assert mana_cost(%i[magic_missile drain shield]), 239

    assert spell_damage([]), 0
    assert spell_damage([:magic_missile]), 4
    assert spell_damage(%i[magic_missile drain]), 6
    assert spell_damage(%i[magic_missile poison drain shield drain]), 26
    assert spell_damage(%i[magic_missile poison drain]), 12

    assert boss_damage([]), 0
    assert boss_damage([:magic_missile]), 0
    assert boss_damage(%i[magic_missile shield]), 8
    assert boss_damage(%i[magic_missile shield drain]), 7
    assert boss_damage(%i[magic_missile shield drain poison drain]), 7

    assert mana_pool([]), 500
    assert mana_pool([:magic_missile] * 10), -30
    assert mana_pool(%i[magic_missile recharge]), 218
    assert mana_pool(%i[magic_missile recharge drain]), 347
    assert mana_pool(%i[magic_missile recharge drain poison drain]), 404

    :ok
  end

  def part_a
    solve_a
  end

  def part_b
    raise NotImplementedError
  end

  private

  PLAYER = { hp: 50, mana: 500 }.freeze
  BOSS = { hp: 55, damage: 8 }.freeze

  SPELLS = {
    magic_missile: { mana: 53, damage: 4 },
    drain: { mana: 73, damage: 2, heal: 2 },
    shield: { mana: 113, armor: 7, turns: 6 },
    poison: { mana: 173, damage: 3, turns: 6 },
    recharge: { mana: 229, regen: 101, turns: 5 }
  }.freeze

  def next_spells(prior_spells)
    prior_spells = prior_spells[-2..] if prior_spells.size >= 2
    effects = SPELLS.filter { |_, v| v.key?(:turns) }.keys - prior_spells
    SPELLS.reject { |_, v| v.key?(:turns) }.keys + effects
  end

  def mana_cost(spells)
    spells.reduce(0) { |cost, spell| cost + SPELLS[spell][:mana] }
  end

  def spell_ticks(spell, size, index)
    [0, [spell[:turns], 2 * (size - index - 1)].min].max
  end

  def spell_damage(spells)
    spells.each_with_index.reduce(0) do |damage, entry|
      k, i = entry
      spell = SPELLS[k]
      next damage unless spell.key?(:damage)

      ticks = spell.key?(:turns) ? spell_ticks(spell, spells.size, i) : 1
      damage + spell[:damage] * ticks
    end
  end

  def boss_damage(spells)
    return 0 if spells.size < 2

    shield = SPELLS[:shield]
    armor = SPELLS[:shield][:armor]
    armor_reduction = spells.each_with_index
      .filter { |spell, _i| spell == :shield }
      .map { |_, i| armor * spell_ticks(shield, spells.size, i).fdiv(2).ceil }
      .sum

    healing_reduction = spells.map { |s| SPELLS[s].fetch(:heal, 0) }.sum

    max_damage = BOSS[:damage] * [0, spells.size - 1].max
    [1, max_damage - armor_reduction - healing_reduction].max
  end

  def mana_pool(spells)
    spells.each_with_index.reduce(PLAYER[:mana]) do |pool, entry|
      k, i = entry
      spell = SPELLS[k]

      regen = spell.fetch(:regen, 0)
      regen *= spell_ticks(spell, spells.size, i) if k == :recharge
      pool - spell[:mana] + regen
    end
  end

  def player_dead?(spells)
    boss_damage(spells) >= PLAYER[:hp]
  end

  def boss_dead?(spells)
    spell_damage(spells) >= BOSS[:hp]
  end

  def solve_a
    mana = Float::INFINITY
    minimum_cost = SPELLS.values.map { |v| v[:mana] }.min
    queue = [[]]

    until queue.empty?
      spells = queue.pop
      cost = mana_cost(spells)

      next if cost >= mana || mana_pool(spells).negative?
      next if player_dead?(spells)

      if boss_dead?(spells)
        mana = cost if cost < mana
      else
        next_spells(spells).each { |s| queue << spells + [s] }
      end
    end

    mana
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
