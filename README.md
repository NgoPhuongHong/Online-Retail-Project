# I - Online-Retail-Project
Đây là một tập dữ liệu chứa tất cả các giao dịch diễn ra từ ngày 01/12/2010 đến ngày 09/12/2011 của một công ty bán lẻ trực tuyến không có cửa hàng tại UK. Công ty này chủ yếu bán các mặt hàng quà tặng độc đáo cho mọi dịp. Nhiều khách hàng của công ty là các nhà bán buôn

# II - Data Cleaning
- Check giá trị null => loại bỏ tất cả dòng chứa giá trị null
- Check datatype
- Một số dòng mang giá trị âm => điều chỉnh lại
- Thêm cột amount = quantity*unit_price
- Trích xuất thời gian từ cột invoice_date (hour, day, month, year_month, week_days)
- Xóa những dòng bị duplicate

# III - Exploratory Data Analysis (EDA) 

## How many monthly active user (MAU) each month?

![Monthly active user - MAU](images/1.jpg)

Số lượng khách hàng có xu hướng tăng theo hằng tháng. Khoảng thời gian tăng trưởng mạnh nhất từ tháng 8/2011 - 11/2011 (tăng từ 977 KH lên 1705 KH => tăng 74.5%) 
=> Số lượng KH tăng mạnh cuối năm có thể do nhu cầu mua sắp cuối năm tăng cao để đón năm mới hoặc công ty giảm giá sản phẩm cuối năm (Black Friday )hay thay đổi chiến lược Marketing 

## How are the number of orders and total order amount each month?


