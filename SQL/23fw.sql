---------------------------------------------------------------------2.3---------------------------------------------------------------------
--Function 1: Tìm kiếm và hiển thị thông tin các khóa học trong một danh mục cụ thể,
--có điểm đánh giá trung bình cao hơn hoặc bằng một mức điểm cho trước
GO
CREATE PROCEDURE GetCoursesInCategoryByMinRating
    @CategoryName NVARCHAR(255),
    @MinRating DECIMAL(10,3)
AS
BEGIN
    -- Kiểm tra tham số đầu vào
    IF @MinRating < 1 OR @MinRating > 5
    BEGIN
        RAISERROR('Rating phải nằm trong khoảng từ 1 đến 5', 16, 1)
        RETURN
    END

    SELECT
		cat.CategoryName,
        c.CourseName,
	 COUNT(r.ReviewID) as TotalReviews,
        c.CourseAverageRating,
        c.CoursePrice,
        c.CourseStartDate,
        c.CourseEndDate,
        cat.CategoryName
    FROM Course c
    INNER JOIN Category cat ON c.CategoryID = cat.CategoryID
    LEFT JOIN Review r ON c.CourseID = r.CourseID
    WHERE
        cat.CategoryName LIKE N'%' + @CategoryName + '%'
        AND c.CourseAverageRating >= @MinRating
    GROUP BY
		cat.CategoryName,
        c.CourseName,
        c.CourseAverageRating,
        c.CoursePrice,
        c.CourseStartDate,
        c.CourseEndDate,
        cat.CategoryName
    HAVING
        COUNT(r.ReviewID) > 0  -- Thay đổi điều kiện HAVING
    ORDER BY
        c.CourseAverageRating DESC;
END;


-- Thực thi câu lệnh mẫu
EXEC GetCoursesInCategoryByMinRating @CategoryName = N'Lập trình', @MinRating = 4.0


--Function 2: lấy danh sách các mã giảm giá còn hiệu lực tại một thời điểm cụ thể,
--kèm theo thống kê số lượng đơn hàng đã sử dụng mã giảm giá đó.

GO
CREATE PROCEDURE sp_GetValidCoupons
    @CheckDate DATE
AS
BEGIN
    SELECT
        c.CouponID,
        c.CouponTitle,
        c.CouponValue,
        c.CouponType,
        c.CouponStartDate,
        c.CouponExpire,
        c.CouponMaxDiscount,
        COUNT(DISTINCT o.OrderID) as TotalOrders
    FROM Coupon c, Orders o
    WHERE c.CouponStartDate <= @CheckDate
    AND c.CouponExpire >= @CheckDate
    AND c.CouponID = o.CouponID
    GROUP BY
        c.CouponID,
        c.CouponTitle,
        c.CouponValue,
        c.CouponType,
        c.CouponStartDate,
        c.CouponExpire,
        c.CouponMaxDiscount
    ORDER BY
        c.CouponExpire ASC;
END;

-- Thực thi câu lệnh mẫu
EXEC sp_GetValidCoupons @CheckDate = '2024-03-27'