module RoomsHelper
  def diamond_color_class(color)
    case color
    when "blue" then "text-blue-500"
    when "green" then "text-green-500"
    when "red" then "text-red-500"
    when "purple" then "text-purple-500"
    when "orange" then "text-orange-500"
    when "teal" then "text-teal-500"
    when "pink" then "text-pink-500"
    when "yellow" then "text-yellow-500"
    else "text-slate-500"
    end
  end
end
