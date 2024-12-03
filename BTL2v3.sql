
--Bảng Chỉnh sửa
CREATE TABLE Edit (
    EditID INT IDENTITY (1,1) PRIMARY KEY,
    EditTime TIME,
    EditDescription VARCHAR(255),
    EditAdminID INT,
    EditCouponID INT,
    EditCourseID INT,
);


--Bảng Admin
CREATE TABLE Admin(
    AdminID INT IDENTITY (1,1) PRIMARY KEY,
);

--Bảng giảng viên
CREATE TABLE Teacher(
    TeacherID INT IDENTITY (1,1) PRIMARY KEY,
    TeacherDescription VARCHAR(255),
)

--Bảng danh mục
CREATE TABLE Category(
    CategoryID INT IDENTITY (1,1) PRIMARY KEY,
    CategoryName VARCHAR(255),
    CategoryDescription VARCHAR(255),
);

--Bảng khoá học
CREATE TABLE Course(
    CourseID INT IDENTITY (1,1) PRIMARY KEY,
    CourseName VARCHAR(255),
    CourseStatus VARCHAR(255),
    CourseDescription VARCHAR(255),
    CoursePrice INT,
    CourseImage VARCHAR(255),
    CourseStartDate DATE,
    CourseEndDate DATE,
    CategoryID INT,
);

--Giảng viên dạy khoá học
CREATE TABLE TeacherCourse(
    TeacherID INT,
    CourseID INT,
)


--Phiếu giảm giá
CREATE TABLE Coupon(
    CouponID INT IDENTITY (1,1) PRIMARY KEY,
    CouponTitle VARCHAR(255),
    CouponValue INT,
    CouponType VARCHAR(255),
    CouponStartDate DATE,
    CouponExpire DATE,
    CouponMaxDiscount INT,
)

--Phiếu giảm giá thuộc giỏ hàng
CREATE TABLE CouponCart(
    CouponID INT,
    CartID INT,
)