# coding: utf-8
MEMBER_LIST = 'member.csv'
DUTY_ROLL = %w(ゴミ ゴミ 掃除機 掃除機 テーブル テーブル)
POS_TEXT = 'pos.txt'
DUTY_LIST = 'duty.csv'

def member_list
  members = []

  File.read(MEMBER_LIST).each_line do |line|
    name, can = *line.split(',')
    members << {name: name, can: eval(can)}
  end

  members
end

def create_duty(members)
  DUTY_ROLL.inject([]) do |duties, roll|
    member = members.sample
    members.delete member
    duties << [roll, member]
  end
end

def pos_read
  File.read(POS_TEXT).to_i
end

def pos_write(pos)
  File.open(POS_TEXT, 'w') {|f| f.puts(pos) }
end


def select_duty_members
  duty_size = DUTY_ROLL.size
  duty_members = []
  pos = pos_read
  members = member_list

  while duty_size > 0
    pos = 0 unless pos < members.size

    if members[pos][:can]
      duty_members << members[pos][:name]
      duty_size -= 1
    end

    pos += 1
  end
  pos_write(pos)

  duty_members
end

if __FILE__ == $0
  File.open(DUTY_LIST, 'w') do |f|
    create_duty(select_duty_members).each do |duty|
      f.puts duty.join(',')
    end
  end
end
