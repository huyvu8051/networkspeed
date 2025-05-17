#!/bin/bash

# Lấy số byte hiện tại từ netstat
get_bytes() {
  netstat -ib | awk '$1 == "en0" && $7 ~ /^[0-9]+$/ {in_bytes=$7} $1 == "en0" && $10 ~ /^[0-9]+$/ {out_bytes=$10} END {print in_bytes, out_bytes}'
}

# Hàm định dạng tốc độ
format_speed() {
  speed=$1
  if ((speed >= 1024)); then
    printf "%.2fM" "$(echo "$speed / 1024" | bc -l)"
  else
    echo "${speed}K"
  fi
}

# Khởi tạo giá trị ban đầu
read prev_in prev_out <<<$(get_bytes)

while true; do
  sleep 1
  # Lấy giá trị mới
  read curr_in curr_out <<<$(get_bytes)

  # Tính toán tốc độ
  in_speed=$(((curr_in - prev_in) / 1024))
  out_speed=$(((curr_out - prev_out) / 1024))

  # Cập nhật giá trị cũ
  prev_in=$curr_in
  prev_out=$curr_out

  # In kết quả
  echo "$(format_speed $in_speed)/$(format_speed $out_speed)"
done
