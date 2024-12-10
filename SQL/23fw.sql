--Procedure 1: Tìm kiếm và hiển thị thông tin các khóa học trong một danh mục cụ thể,
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


-- Procedure 2: Lấy danh sách các mã giảm giá hợp lệ
GO
CREATE OR ALTER PROCEDURE sp_GetValidCoupons
AS
BEGIN
    DECLARE @CurrentDate DATE = GETDATE();

    SELECT
        c.CouponID,
        c.CouponTitle,
        c.CouponValue,
        c.CouponType,
        c.CouponStartDate,
        c.CouponExpire,
        c.CouponMaxDiscount,
        (
            SELECT COUNT(DISTINCT co.CourseID)
            FROM Orders o, CourseOrder co
            WHERE o.CouponID = c.CouponID
            AND co.OrderID = o.OrderID
        ) as TotalAffectedCourses
    FROM Coupon c
    WHERE c.CouponStartDate <= @CurrentDate
    AND c.CouponExpire >= @CurrentDate
    ORDER BY TotalAffectedCourses DESC, c.CouponExpire ASC;
END;

EXEC GetCoursesInCategoryByMinRating @CategoryName = N'Lập trình', @MinRating = 4.0

EXEC sp_GetValidCoupons;