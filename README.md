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

![Monthly number of orders and total order amount](images/2.jpg)


Kết quả cho thấy số lượng đơn hàng và doanh thu hằng tháng của công ty đều tăng lên, tỷ lệ thuận với số lượng KH hằng tháng phía trên. Tăng mạnh nhất từ tháng 8/11- 11/11

## Analyze the number of customers by weekdays and by hour

![The number of customers by weekdays and by hour](images/3.jpg)

Công ty không có KH mua hàng vào thứ 7. Số lượng KH mua hàng nhiều rơi vào khung giờ từ 9h đến 15h (đặc biệt là khung giờ nghỉ trưa 12h) và tập trung chủ yếu vào các ngày giữa tuần từ thứ 3 đến thứ 5 thay vì cuối tuần. 

## Top 10 Contries bring most sales for the company?

![Top 10 Countries Bring Most Sales](images/4.jpg)

Anh là quốc gia mang lại doanh thu cao nhất và cao vượt trội so với các quốc gia khác (cao hơn gần 7 triêu) => đây là thị trường chủ lực có vai trò quan trọng => công ty nên tập trung vào đây là chính và có thể đầu tư thêm ở các nước Netherlands, EIRE, Germany..

## Countries with most AOV - Average Order Value

![Top 10 Average Order Value](images/5.jpg)



## How many new and old customers do you have each month

![Monthly New vs Returning Customers](images/6.jpg)

Số lượng KH cũ của công ty vấn quay lại mua tăng ngày càng nhiều so với lượng khách mới thì có chiều hướng hơi giảm 
=> công ty tập trung vào giữ chân KH hàng tốt (có nhiều ưu đãi cho KH cũ) hoặc chất lượng sản phẩm và giá thành hợp lý nên KH quay lại 

## Considering the new customers of December 2010, what is the average transaction value of these customers in each month when they return

!Average transaction value of new cust in 2010-12](images/7.jpg)

Khách hàng đã mua hàng vào 12/2010 quay lại mua hàng nhiều hơn có xu hướng tăng dần qua các tháng, tăng mạnh nhất vào khoảng 7/2011- 10/2011
=> công ty giữ chân được KH có thể do sản phẩm tốt đáp ứng nhu cầu KH, chiến lược chăm sóc KH tốt, khuyến mãi tốt hoặc nhu cầu mua hàng cuối năm


## Customer Segmentation

Phân khúc Khác Hàng sẽ dựa vào 2 phân khúc:
- Recency - Gần nhất: Recency là chỉ số đo lường khoảng thời gian kể từ lần cuối cùng khách hàng tương tác với sản phẩm hoặc dịch vụ của bạn. Câu hỏi chúng ta cần đặt ra là: `"Lần cuối cùng khách hàng này mua hàng của chúng ta đến hiện tại là mấy ngày
      + Khách hàng mới mua gần đây: Đây là những người đã mua sản phẩm hoặc dịch vụ gần đây nhất. Họ có thể đang cảm thấy hài lòng hoặc có nhu cầu cao.
      + Khách hàng mua từ lâu: Họ đã không mua hàng trong một thời gian dài, có thể họ đã quên sản phẩm của chúng ta hoặc đã tìm thấy sự lựa chọn khác.
  
- Frequency - Tần suất: Frequency đo lường số lần khách hàng mua hàng trong một khoảng thời gian nhất định. Câu hỏi cần trả lời là: `"Khách hàng này đã mua hàng bao nhiêu lần
      + Khách hàng thường xuyên: Họ mua hàng nhiều lần, cho thấy họ trung thành và có thể là những người yêu thích sản phẩm.
      + Khách hàng ít mua: Họ ít mua hàng, có thể họ chỉ mua sản phẩm khi cần thiết hoặc có dịp đặc biệt.

  

