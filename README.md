# I - Online-Retail-Project
Đây là một tập dữ liệu chứa tất cả các giao dịch diễn ra từ ngày 01/12/2010 đến ngày 09/12/2011 của một công ty bán lẻ trực tuyến không có cửa hàng tại UK. Công ty này chủ yếu bán các mặt hàng quà tặng độc đáo cho mọi dịp. Nhiều khách hàng của công ty là các nhà bán buôn

# II - Data Cleaning
- Check giá trị null => loại bỏ tất cả dòng chứa giá trị null
- Check datatype
- Một số dòng mang giá trị âm => điều chỉnh lại
- Thêm cột amount = quantity*unit_price
- Trích xuất thời gian từ cột invoice_date (hour, day, month, year_month, week_days)
- Xóa những dòng bị duplicate

# III - Exploratory Data Analysis (EDA) & Visualization

## 1. How many monthly active user (MAU) each month?

![Monthly active user - MAU](images/1.jpg)


Số lượng khách hàng có xu hướng tăng theo hằng tháng. Khoảng thời gian tăng trưởng mạnh nhất từ tháng 8/2011 - 11/2011 (tăng từ 977 KH lên 1705 KH => tăng 74.5%) 
=> Số lượng KH tăng mạnh cuối năm có thể do nhu cầu mua sắp cuối năm tăng cao để đón năm mới hoặc công ty giảm giá sản phẩm cuối năm (Black Friday )hay thay đổi chiến lược Marketing 

## 2. How are the number of orders and total order amount each month?

![Monthly number of orders and total order amount](images/2.jpg)


Kết quả cho thấy số lượng đơn hàng và doanh thu hằng tháng của công ty đều tăng lên, tỷ lệ thuận với số lượng KH hằng tháng phía trên. Tăng mạnh nhất từ tháng 8/11- 11/11

## 3. Analyze the number of customers by weekdays and by hour

![The number of customers by weekdays and by hour](images/3.jpg)

Công ty không có KH mua hàng vào thứ 7. Số lượng KH mua hàng nhiều rơi vào khung giờ từ 9h đến 15h (đặc biệt là khung giờ nghỉ trưa 12h) và tập trung chủ yếu vào các ngày giữa tuần từ thứ 3 đến thứ 5 thay vì cuối tuần. 

## 4. Top 10 Contries bring most sales for the company?

![Top 10 Countries Bring Most Sales](images/4.jpg)

Anh là quốc gia mang lại doanh thu cao nhất và cao vượt trội so với các quốc gia khác (cao hơn gần 7 triêu) => đây là thị trường chủ lực có vai trò quan trọng => công ty nên tập trung vào đây là chính và có thể đầu tư thêm ở các nước Netherlands, EIRE, Germany..

## 5. Countries with most AOV - Average Order Value

![Top 10 Average Order Value](images/5.jpg)



## 6. How many new and old customers do you have each month

![Monthly New vs Returning Customers](images/6.jpg)

Số lượng KH cũ của công ty vấn quay lại mua tăng ngày càng nhiều so với lượng khách mới thì có chiều hướng hơi giảm 
=> công ty tập trung vào giữ chân KH hàng tốt (có nhiều ưu đãi cho KH cũ) hoặc chất lượng sản phẩm và giá thành hợp lý nên KH quay lại 

## 7. Considering the new customers of December 2010, what is the average transaction value of these customers in each month when they return

![Average transaction value of new cust in 2010-12](images/7.jpg)

Khách hàng đã mua hàng vào 12/2010 quay lại mua hàng nhiều hơn có xu hướng tăng dần qua các tháng, tăng mạnh nhất vào khoảng 7/2011- 10/2011
=> công ty giữ chân được KH có thể do sản phẩm tốt đáp ứng nhu cầu KH, chiến lược chăm sóc KH tốt, khuyến mãi tốt hoặc nhu cầu mua hàng cuối năm


## 8.Customer Segmentation

Phân khúc Khác Hàng sẽ dựa vào 2 phân khúc:
- Recency - Gần nhất: Recency là chỉ số đo lường khoảng thời gian kể từ lần cuối cùng khách hàng tương tác với sản phẩm hoặc dịch vụ của bạn. Câu hỏi chúng ta cần đặt ra là: `"Lần cuối cùng khách hàng này mua hàng của chúng ta đến hiện tại là mấy ngày
      + Khách hàng mới mua gần đây: Đây là những người đã mua sản phẩm hoặc dịch vụ gần đây nhất. Họ có thể đang cảm thấy hài lòng hoặc có nhu cầu cao.
      + Khách hàng mua từ lâu: Họ đã không mua hàng trong một thời gian dài, có thể họ đã quên sản phẩm của chúng ta hoặc đã tìm thấy sự lựa chọn khác.
  
- Frequency - Tần suất: Frequency đo lường số lần khách hàng mua hàng trong một khoảng thời gian nhất định. Câu hỏi cần trả lời là: `"Khách hàng này đã mua hàng bao nhiêu lần
      + Khách hàng thường xuyên: Họ mua hàng nhiều lần, cho thấy họ trung thành và có thể là những người yêu thích sản phẩm.
      + Khách hàng ít mua: Họ ít mua hàng, có thể họ chỉ mua sản phẩm khi cần thiết hoặc có dịp đặc biệt.

  
 ![segmentation](images/11.jpg) 

 Map Khách Hàng vào các phân khúc sau: 

![segmentation2](images/12.jpg)

Visualization 

![Total amount by customer segment](images/8.jpg) 

tỷ lệ khách hàng và doanh thu theo từng phân khúc không tương đồng với nhau
Low value chiếm 29% lượng KH nhưng chỉ đem về doanh thu 5.1%
ngược lại Loyal chỉ chiếm 12.1% lượng KH nhưng đem lại doanh thu rất cao 46.9% => cần chú ý vào tệp KH này và chăm sóc tốt hơn VIP
Losing potential loyal chiếm lượng KH lớn nhất 34.7%, doanh thu đem lại 19.2% cũng tương đối nhưng vẫn chưa hiệu quả => tệp KH tiềm năng cần phát triển

## 9. Customer Behavior Analysis Using Cohort Analysis

![Monthly Customer Retention Cohort Analysis](images/9.jpg) 

- Retention giảm mạnh ngay sau tháng đầu tiên (chỉ còn khoảng 18%–30%), cho thấy tỷ lệ churn sau lần mua đầu rất cao (~70–80%). 
- Không quan sát thấy xu hướng cải thiện retention theo thời gian giữa các cohort, cho thấy chiến lược giữ chân khách hàng chưa có sự thay đổi rõ rệt
- Cohort cuối năm 2010 có tỷ lệ quay lại vượt trội so với các cohort khác, có thể liên quan đến yếu tố mùa vụ hoặc các chiến dịch marketing cuối năm

=> Doanh nghiệp nên tập trung vào chiến lược giữ chân sau lần mua đầu tiên (đẩy mạnh chăm sóc KH sau mua, có chương trình cho KH thành viên,...)

## 10. ABC Analysis

![ABC Analysis](images/10.jpg)

Nhóm A là nhóm sản phẩm chiến lược. Tuy chỉ chiếm 21% trên tổng số lượng sản phẩm nhưng đem lại doanh thu cao 80%.
=> Nên tập trung vào nhóm này. Kiểm tra kỹ tồn kho tránh out-of-stock vì nó sẽ ảnh hướng đến doanh thu của công ty.
Đồng thời đẩy mạnh marketing và các chương trình khuyến mãi cho nhóm này
Nhóm B chiếm 15% doanh thu - nhóm trung bình
=> Nếu có chiến lược marketing và chương trình giá tốt => có tiềm năng phát triển thành nhóm A trong tương lai
Nhóm C - nhóm chiếm số lượng nhiều nhất nhưng doanh thu chỉ 5%
=> Có thể giảm bớt số lượng tồn kho, thậm chí 1 số sản phẩm doanh thu quá thấp có thể loại bỏ bớt để tiết kiệm chi phí marketing, kho cũng như nhân lực


 

  

