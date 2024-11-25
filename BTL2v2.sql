--------------------------TẠO DATABASE-------------------------

--Người dùng hệ thống
CREATE TABLE Users(
    Username_ID INT PRIMARY KEY,
    User_Email VARCHAR(255) UNIQUE,
    User_Phone_Number VARCHAR (10),
    User_Password VARCHAR(255),
    User_Address VARCHAR(255),
    User_Image TEXT,
    User_Name VARCHAR(255),
)

--Admin
CREATE TABLE Admin(
    Admin_ID INT PRIMARY KEY,

    FOREIGN KEY (Admin_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
)

-- Giảng viên
CREATE TABLE Teacher(
    Teacher_ID INT PRIMARY KEY,
    Teacher_Description TEXT,

    FOREIGN KEY (Teacher_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

--Giỏ hàng
CREATE TABLE Cart(
    Cart_ID INT PRIMARY KEY,
    Student_ID INT,
);

-- Phiếu giảm giá
CREATE TABLE Coupon(
    Coupon_ID INT PRIMARY KEY,
    Coupon_title VARCHAR(255),
    Coupon_Value INT,
    Coupon_Type VARCHAR(255),
    Coupon_Start_Date DATE,
    Coupon_Expiry_Date DATE,
    Coupon_Max_Discount INT,
);

--Học viên
CREATE TABLE Student(
    Student_ID INT PRIMARY KEY,
    Student_Cart_ID INT,

    FOREIGN KEY (Student_Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

-- Bảng danh mục
CREATE TABLE Categories (
    Categories_ID INT PRIMARY KEY,
    Categories_Name VARCHAR(255),
    Categories_Description TEXT,
);


--Khoá học
CREATE TABLE Course(
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(255),
    Course_Status VARCHAR(255),
    Course_Description TEXT,
    Course_Price INT,
    Course_Image TEXT,
    Course_Start_Date DATE,
    Course_End_Date DATE,
    Course_Categories_ID INT,

    FOREIGN KEY (Course_Categories_ID) REFERENCES Categories(Categories_ID) ON DELETE CASCADE,
);


-- Bảng chỉnh sửa
CREATE TABLE Edit (
    Edit_ID INT PRIMARY KEY,
    Edit_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Edit_Content TEXT,
    Edit_Admin_ID INT,
    Edit_Coupon_ID INT,
    EDIT_Course_ID INT,

    FOREIGN KEY (Edit_Admin_ID) REFERENCES Admin(Admin_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Giảng viên dạy khoá học
CREATE TABLE Teacher_Course(
    Teacher_ID INT,
    Course_ID INT,

    PRIMARY KEY (Teacher_ID, Course_ID),
    FOREIGN KEY (Teacher_ID) REFERENCES Teacher(Teacher_ID) ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Khoá học áp dụng phiếu giảm giá
CREATE TABLE Course_Coupon(
    Course_ID INT,
    Coupon_ID INT,
    PRIMARY KEY (Course_ID, Coupon_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
);


--Khoá học được thêm vào giỏ hàng
CREATE TABLE Course_Cart(
    Course_ID INT,
    Cart_ID INT,
    PRIMARY KEY (Course_ID, Cart_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
);


--Khoá học có học viên
CREATE TABLE Course_Student(
    Course_ID INT,
    Student_ID INT,
    PRIMARY KEY (Course_ID, Student_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Phương thức thanh toán
CREATE TABLE Payment_Method(
    Payment_Method_ID INT PRIMARY KEY,
    Payer_Name VARCHAR(255),
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
);

--Momo
CREATE TABLE Momo(
    Momo_ID INT PRIMARY KEY, --mã thanh toán
    Momo_Phone_Number VARCHAR(10), --số điện thoại

    FOREIGN KEY (Momo_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Internet banking
CREATE TABLE Internet_Banking(
    Internet_Banking_ID INT PRIMARY KEY, --mã thanh toán
    Internet_Banking_Bank_Name VARCHAR(255),

    FOREIGN KEY (Internet_Banking_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Visa
CREATE TABLE Visa(
    Visa_ID INT PRIMARY KEY, --mã thanh toán
    Visa_Card_Number VARCHAR(16), --số thẻ
    Visa_Expiry_Date DATE, --ngày hết hạn

    FOREIGN KEY (Visa_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Đơn hàng
CREATE TABLE Orders (
    Orders_ID INT PRIMARY KEY,
    Orders_Payment_Status VARCHAR(255),
    Orders_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Payment_ID INT, --mã thanh toán
    Student_ID INT, --mã học viên

    FOREIGN KEY (Payment_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);

--Khoá học được thêm vào đơn hàng
CREATE TABLE Course_Order(
    Course_ID INT,
    Order_ID INT,
    PRIMARY KEY (Course_ID, Order_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Orders_ID) ON DELETE CASCADE,
);

--Đánh giá
CREATE TABLE Reviews (
    Reviews_ID INT,
    Course_ID INT,
    Reviews_Score INT,
    Reviews_Content TEXT,
    Student_ID INT,
    PRIMARY KEY (Reviews_ID, Course_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Người đại diện
CREATE TABLE Guardians(
    Guardians_ID INT,
    Student_ID INT,
    Guardians_Name VARCHAR(255),
    Guardians_Email VARCHAR(255) UNIQUE,
    Guardians_Phone_Number VARCHAR(10),
    PRIMARY KEY (Guardians_ID, Student_ID),

    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
)

--Chương
CREATE TABLE Chapter(
    Chapter_Name VARCHAR(255),
    Course_ID INT,
    PRIMARY KEY (Chapter_Name, Course_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE
);

--Bài học
CREATE TABLE Lesson (
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Lesson_Title VARCHAR(255),
    Lesson_Content TEXT,
    Lesson_Duration INT,
    PRIMARY KEY (Lesson_Order, Course_ID, Chapter_Name),
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài tập
CREATE TABLE Exercise(
    Exercise_Order INT,
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Exercise_Title VARCHAR(255),
    Exercise_Solution TEXT,
    Exercise_Number_Of_Correct_Answers INT,
    Exercise_Content TEXT,

    PRIMARY KEY (Exercise_Order, Lesson_Order, Course_ID, Chapter_Name),

    FOREIGN KEY (Lesson_Order, Course_ID, Chapter_Name) REFERENCES Lesson(Lesson_Order, Course_ID, Chapter_Name) ON DELETE CASCADE,
)

--Tài liệu
CREATE TABLE Document(
    Document_ID INT PRIMARY KEY,
    Course_ID INT,
    Chapter_Name VARCHAR(255),
    Document_Author VARCHAR(255),
    Document_Title VARCHAR(255),
    Document_Size INT,
    Document_Type VARCHAR(255),
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài kiểm tra
CREATE TABLE Test(
    Test_Order INT,
    Chapter_Name VARCHAR(255),
    Course_ID INT,
    Test_Number_Of_Questions INT,
    Test_Solution TEXT,
    Test_TakenTimes INT,
    Test_Number_Of_Correct_Answers INT,
    Test_Content TEXT,

    PRIMARY KEY (Test_Order, Chapter_Name, Course_ID),

    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)




--------------------------INSERT DỮ LIỆU-------------------------
INSERT INTO Users(Username_ID, User_Email, User_Phone_Number, User_Password, User_Address, User_Image, User_Name)
VALUES
    (1, 'minhnhut.tran@gmail.com', '0941063485', 'abc12345', 'Tp. Hồ Chí Minh', 'nhut_image.jpg', 'Trần Minh Nhựt'),
    (2, 'hoa.le@gmail.com', '0973456789', 'hoa_9876', 'Hà Nội', 'hoa_image.jpg', 'Lê Thị Hoa'),
    (3, 'anh.nguyen@gmail.com', '0932123456', 'nguyen123', 'Đà Nẵng', 'anh_image.jpg', 'Nguyễn Văn Anh'),
    (4, 'huong.pham@gmail.com', '0912345678', 'huong_456', 'Hải Phòng', 'huong_image.jpg', 'Phạm Thị Hương'),
    (5, 'long.nguyen@gmail.com', '0967890123', 'long_pass1', 'Cần Thơ', 'long_image.jpg', 'Nguyễn Thành Long'),
    (6, 'khanh.le@gmail.com', '0923456781', 'khanh!2023', 'Huế', 'khanh_image.jpg', 'Lê Thị Khánh'),
    (7, 'bao.vo@gmail.com', '0981234567', 'bao_pass123', 'Tp. Hồ Chí Minh', 'bao_image.jpg', 'Võ Bảo Khánh'),
    (8, 'lan.do@gmail.com', '0945678901', 'lan_7890', 'Hà Nội', 'lan_image.jpg', 'Đỗ Thị Lan'),
    (9, 'son.pham@gmail.com', '0916782345', 'son_abc987', 'Đà Nẵng', 'son_image.jpg', 'Phạm Quang Sơn'),
    (10, 'tien.nguyen@gmail.com', '0937894561', 'tien_secure', 'Hải Phòng', 'tien_image.jpg', 'Nguyễn Minh Tiến'),
    (11, 'thao.nguyen@gmail.com', '0901234567', 'thao!2345', 'Tp. Hồ Chí Minh', 'thao_image.jpg', 'Nguyễn Thị Thảo'),
    (12, 'trung.le@gmail.com', '0912345679', 'trung1234', 'Hà Nội', 'trung_image.jpg', 'Lê Minh Trung'),
    (13, 'minh.tung@gmail.com', '0932345678', 'minhtung!56', 'Đà Nẵng', 'minhtung_image.jpg', 'Nguyễn Minh Tùng'),
    (14, 'thuy.pham@gmail.com', '0965432109', 'thuy!789', 'Hải Phòng', 'thuy_image.jpg', 'Phạm Thị Thùy'),
    (15, 'hoang.nguyen@gmail.com', '0909876543', 'hoang!1234', 'Cần Thơ', 'hoang_image.jpg', 'Nguyễn Hoàng Sơn'),
    (16, 'lan.pham@gmail.com', '0941234560', 'lan1234', 'Huế', 'lan_image.jpg', 'Phạm Thị Lan'),
    (17, 'hieu.nguyen@gmail.com', '0934567890', 'hieu!8901', 'Tp. Hồ Chí Minh', 'hieu_image.jpg', 'Nguyễn Hữu Hiếu'),
    (18, 'nhung.dang@gmail.com', '0975678901', 'nhung_2345', 'Hà Nội', 'nhung_image.jpg', 'Đặng Thị Nhung'),
    (19, 'duy.nguyen@gmail.com', '0923456789', 'duy1234pass', 'Đà Nẵng', 'duy_image.jpg', 'Nguyễn Minh Duy'),
    (20, 'vutranh@gmail.com', '0917896543', 'vutran123', 'Hải Phòng', 'vutran_image.jpg', 'Trần Vũ');



INSERT INTO Admin(Admin_ID)
VALUES (1), (2), (3);

INSERT INTO Teacher(Teacher_ID, Teacher_Description)
VALUES
    (4, 'Giáo viên Toán với 10 năm kinh nghiệm giảng dạy tại các trường chuyên.'),
    (5, 'Giáo viên Văn, chuyên nghiên cứu và giảng dạy văn học hiện đại Việt Nam.'),
    (6, 'Giáo viên Lý, có bằng Thạc sĩ về Vật lý ứng dụng từ trường Đại học Bách khoa.'),
    (7, 'Giáo viên Hóa, từng giành giải nhất kỳ thi Hóa học quốc gia.'),
    (8, 'Giáo viên Sinh, có kinh nghiệm giảng dạy tại trường THPT chuyên.');

INSERT INTO Cart(Cart_ID)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

INSERT INTO Student(Student_ID, Student_Cart_ID)
VALUES (9, 1), (10, 2), (11, 3), (12, 4), (13, 5), (14, 6), (15, 7), (16, 8), (17, 9), (18, 10), (19, 11), (20, 12);

INSERT INTO Coupon(Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount)
VALUES
    (1, 'Giảm giá khai trương', 10, 'Percent', '2023-01-01', '2023-12-31', 100),
    (2, 'Ưu đãi khách hàng mới', 20, 'Percent', '2023-02-01', '2023-12-31', 200),
    (3, 'Giảm giá mùa hè', 30, 'Percent', '2023-06-01', '2023-08-31', 300),
    (4, 'Giảm giá cuối năm', 50, 'Percent', '2023-11-01', '2023-12-31', 500),
    (5, 'Ưu đãi VIP', 100, 'Fixed', '2023-01-01', '2024-01-01', 1000);

INSERT INTO Categories(Categories_ID, Categories_Name, Categories_Description)
VALUES
    (1, 'Điện tử', 'Các sản phẩm công nghệ như điện thoại, máy tính, và phụ kiện.'),
    (2, 'Thời trang', 'Quần áo, giày dép, và phụ kiện thời trang cho mọi lứa tuổi.'),
    (3, 'Đồ gia dụng', 'Các sản phẩm phục vụ cho nhu cầu hàng ngày trong gia đình.'),
    (4, 'Thực phẩm', 'Thực phẩm tươi sống, đồ uống, và thực phẩm chế biến sẵn.'),
    (5, 'Sách và văn phòng phẩm', 'Sách giáo khoa, tiểu thuyết, và dụng cụ văn phòng.');



INSERT INTO Course(Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID)
VALUES
    (1, 'Lập trình Python cơ bản', 'Open', 'Khóa học giúp bạn nắm vững các kiến thức cơ bản về Python.', 500, 'python_basic.jpg', '2024-01-01', '2024-06-30', 1),
    (2, 'Phát triển Web với HTML & CSS', 'Open', 'Khóa học cung cấp kiến thức cơ bản về HTML, CSS để xây dựng website.', 400, 'html_css.jpg', '2024-01-15', '2024-07-15', 1),
    (3, 'Kỹ năng thuyết trình', 'Closed', 'Khóa học giúp nâng cao kỹ năng thuyết trình và giao tiếp hiệu quả.', 300, 'presentation.jpg', '2023-03-01', '2023-09-01', 3),
    (4, 'Thiết kế đồ họa với Photoshop', 'Open', 'Khóa học dạy cách sử dụng Photoshop để thiết kế đồ họa chuyên nghiệp.', 600, 'photoshop.jpg', '2024-02-01', '2024-08-01', 1),
    (5, 'Hướng dẫn sử dụng Excel nâng cao', 'Open', 'Khóa học giúp bạn thành thạo các công cụ nâng cao trong Excel.', 450, 'excel_advanced.jpg', '2024-03-01', '2024-09-01', 3),
    (6, 'Nghệ thuật quản lý thời gian', 'Open', 'Khóa học cung cấp các kỹ thuật quản lý thời gian hiệu quả.', 250, 'time_management.jpg', '2024-01-01', '2024-04-30', 3),
    (7, 'Lập trình Java nâng cao', 'Open', 'Khóa học nâng cao kỹ năng lập trình Java, bao gồm OOP và JavaFX.', 700, 'java_advanced.jpg', '2024-05-01', '2024-12-31', 1),
    (8, 'Tiếng Anh giao tiếp cơ bản', 'Open', 'Khóa học cung cấp các kỹ năng giao tiếp tiếng Anh hàng ngày.', 300, 'english_basic.jpg', '2024-01-01', '2024-06-01', 2),
    (9, 'Marketing căn bản', 'Open', 'Khóa học giới thiệu các khái niệm và công cụ cơ bản trong Marketing.', 500, 'marketing.jpg', '2024-04-01', '2024-09-30', 2),
    (10, 'Phân tích dữ liệu với Python', 'Open', 'Khóa học chuyên sâu về phân tích dữ liệu và trực quan hóa với Python.', 800, 'data_analysis.jpg', '2024-02-01', '2024-08-31', 1);




INSERT INTO Edit(Edit_ID, Edit_Time, Edit_Content, Edit_Admin_ID, Edit_Coupon_ID, Edit_Course_ID)
VALUES
    (1, '2023-05-02', 'Cập nhật nội dung khóa học Python cơ bản.', 1, 1, 1),
    (2, '2024-03-01', 'Thay đổi mức giảm giá cho ưu đãi khách hàng mới.', 2, 2, 8),
    (3, '2021-09-02', 'Chỉnh sửa tiêu đề và mô tả của khóa học thuyết trình.', 3, NULL, 3),
    (4, '2023-12-15', 'Gia hạn ngày hết hạn của mã giảm giá Giảm giá cuối năm.', 1, 4, NULL),
    (5, '2024-02-10', 'Thêm chi tiết bài tập thực hành trong khóa học phân tích dữ liệu.', 2, NULL, 10),
    (6, '2024-01-20', 'Cập nhật hình ảnh mới cho khóa học Marketing căn bản.', 3, NULL, 9),
    (7, '2023-08-05', 'Chỉnh sửa mô tả ưu đãi giảm giá mùa hè.', 1, 3, NULL),
    (8, '2024-04-12', 'Thay đổi ngày bắt đầu của khóa học Excel nâng cao.', 2, NULL, 5),
    (9, '2023-11-30', 'Điều chỉnh mức giảm giá và tối đa hóa ưu đãi VIP.', 3, 5, NULL),
    (10, '2024-03-15', 'Thêm nội dung mới vào khóa học Java nâng cao.', 1, NULL, 7);


INSERT INTO Teacher_Course(Teacher_ID, Course_ID)
VALUES (4, 1), (5, 2), (6, 3);

INSERT INTO Course_Coupon(Course_ID, Coupon_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Course_Cart(Course_ID, Cart_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Course_Student(Course_ID, Student_ID)
VALUES (1, 9), (2, 10), (3, 11), (4, 12), (5, 13), (6, 14), (7, 15), (8, 16), (9, 17), (10, 18);

INSERT INTO Payment_Method(Payment_Method_ID, Payer_Name, Payment_Date)
VALUES
    (1, 'Nguyễn Văn A', '2023-01-15'),
    (2, 'Trần Thị B', '2023-02-10'),
    (3, 'Lê Văn C', '2023-03-05'),
    (4, 'Phạm Thị D', '2023-04-20'),
    (5, 'Đỗ Thanh E', '2023-05-25'),
    (6, 'Hoàng Văn F', '2023-06-15'),
    (7, 'Ngô Thị G', '2023-07-10'),
    (8, 'Bùi Văn H', '2023-08-01'),
    (9, 'Phan Thị I', '2023-09-18'),
    (10, 'Vũ Minh J', '2023-10-05');


INSERT INTO Momo(Momo_ID, Momo_Phone_Number)
VALUES (1, '0123456789'), (2, '0123456788'), (3, '0123456787'),
         (4, '0123456786'), (5, '0123456785'), (6, '0123456784'),
         (7, '0123456783'), (8, '0123456782'), (9, '0123456781'),
         (10, '0123456780');


INSERT INTO Internet_Banking(Internet_Banking_ID, Internet_Banking_Bank_Name)
VALUES (1, 'Argibank'), (2, 'VietcomBank'), (3, 'OCB');

INSERT INTO Visa(Visa_ID, Visa_Card_Number, Visa_Expiry_Date)
VALUES (1, '1234567890123456', '2021-12-01'),
       (2, '1234567890123457', '2022-07-05'),
       (3, '1234567890123458', '2022-11-04'),
            (4, '1234567890123459', '2023-01-01'),
            (5, '1234567890123460', '2023-03-15'),
            (6, '1234567890123461', '2023-05-20'),
            (7, '1234567890123462', '2023-07-25'),
            (8, '1234567890123463', '2023-09-30'),
            (9, '1234567890123464', '2023-11-10'),
            (10, '1234567890123465', '2024-01-01');

INSERT INTO Orders(Orders_ID, Orders_Payment_Status, Orders_Time, Payment_ID, Student_ID)
VALUES
    (1, 'Paid', '2023-01-15', 1, 9),
    (2, 'Paid', '2023-02-10', 2, 10),
    (3, 'Paid', '2023-03-05', 3, 11),
    (4, 'Paid', '2023-04-20', 4, 12),
    (5, 'Paid', '2023-05-25', 5, 13),
    (6, 'Paid', '2023-06-15', 6, 14),
    (7, 'Paid', '2023-07-10', 7, 15),
    (8, 'Paid', '2023-08-01', 8, 16),
    (9, 'Paid', '2023-09-18', 9, 17),
    (10, 'Paid', '2023-10-05', 10, 18);

INSERT INTO Course_Order(Course_ID, Order_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Reviews(Reviews_ID, Course_ID, Reviews_Score, Reviews_Content, Student_ID)
VALUES
    (1, 1, 5, 'Khóa học rất dễ hiểu, nội dung rõ ràng và bổ ích.', 10),
    (2, 2, 4, 'Giảng viên nhiệt tình, nhưng cần thêm ví dụ thực tế.', 11),
    (3, 3, 3, 'Khóa học khá ổn, nhưng thời lượng hơi dài.', 12),
    (4, 4, 5, 'Rất hài lòng! Nội dung phù hợp và ứng dụng thực tế tốt.', 14),
    (5, 5, 4, 'Hướng dẫn dễ hiểu, nhưng bài tập hơi ít.', 13),
    (6, 6, 5, 'Khóa học tuyệt vời! Tôi đã cải thiện đáng kể kỹ năng của mình.', 14),
    (7, 7, 3, 'Khóa học khá khó, cần bổ sung thêm tài liệu hướng dẫn.', 15),
    (8, 8, 4, 'Giảng viên giảng bài hay, nhưng tốc độ hơi nhanh.', 16),
    (9, 9, 5, 'Rất đáng giá tiền, kiến thức áp dụng được ngay.', 17),
    (10, 10, 4, 'Khóa học tốt nhưng cần thêm các buổi thực hành.', 18);


INSERT INTO Guardians(Guardians_ID, Student_ID, Guardians_Name, Guardians_Email, Guardians_Phone_Number)
VALUES
    (1, 11, 'Nguyễn Văn A', 'guardian_a@gmail.com', '0945123456'),
    (2, 12, 'Trần Thị B', 'guardian_b@gmail.com', '0932456789'),
    (3, 13, 'Lê Văn C', 'guardian_c@gmail.com', '0912345678'),
    (4, 14, 'Phạm Thị D', 'guardian_d@gmail.com', '0923456781'),
    (5, 15, 'Đỗ Thanh E', 'guardian_e@gmail.com', '0967891234'),
    (6, 16, 'Hoàng Văn F', 'guardian_f@gmail.com', '0982345671'),
    (7, 17, 'Ngô Thị G', 'guardian_g@gmail.com', '0971234568'),
    (8, 18, 'Bùi Văn H', 'guardian_h@gmail.com', '0956781234'),
    (9, 19, 'Phan Thị I', 'guardian_i@gmail.com', '0903456782'),
    (10, 20, 'Vũ Minh J', 'guardian_j@gmail.com', '0934567890');


INSERT INTO Chapter(Chapter_Name, Course_ID)
VALUES
    ('Giới thiệu Python', 1),
    ('Cơ bản về HTML và CSS', 2),
    ('Kỹ năng thuyết trình hiệu quả', 3),
    ('Cách sử dụng Photoshop cơ bản', 4),
    ('Hàm và công thức trong Excel', 5),
    ('Quản lý thời gian trong công việc', 6),
    ('Java nâng cao: OOP và JavaFX', 7),
    ('Giao tiếp tiếng Anh hàng ngày', 8),
    ('Nguyên lý cơ bản trong Marketing', 9),
    ('Phân tích dữ liệu nâng cao với Python', 10);


INSERT INTO Lesson(Lesson_Order, Course_ID, Chapter_Name, Lesson_Title, Lesson_Content, Lesson_Duration)
VALUES
    (1, 1, 'Giới thiệu Python', 'Lập trình cơ bản với Python', 'Học cách cài đặt Python và viết các chương trình đầu tiên', 30),
    (2, 2, 'Cơ bản về HTML và CSS', 'Tạo trang web đầu tiên với HTML và CSS', 'Hướng dẫn xây dựng giao diện web cơ bản', 40),
    (3, 3, 'Kỹ năng thuyết trình hiệu quả', 'Làm chủ kỹ năng thuyết trình', 'Giới thiệu các phương pháp thuyết trình hiệu quả', 50),
    (4, 4, 'Cách sử dụng Photoshop cơ bản', 'Các công cụ cơ bản trong Photoshop', 'Hướng dẫn sử dụng công cụ cắt, chỉnh sửa hình ảnh', 60),
    (5, 5, 'Hàm và công thức trong Excel', 'Sử dụng công thức trong Excel', 'Giới thiệu các hàm và công thức phổ biến trong Excel', 45),
    (6, 6, 'Quản lý thời gian trong công việc', 'Quản lý công việc và thời gian hiệu quả', 'Các phương pháp để quản lý công việc hàng ngày', 35),
    (7, 7, 'Java nâng cao: OOP và JavaFX', 'Lập trình Java với OOP và JavaFX', 'Khám phá lập trình hướng đối tượng và giao diện người dùng', 55),
    (8, 8, 'Giao tiếp tiếng Anh hàng ngày', 'Tiếng Anh giao tiếp trong cuộc sống', 'Học các cụm từ thông dụng và cách giao tiếp hiệu quả', 40),
    (9, 9, 'Nguyên lý cơ bản trong Marketing', 'Marketing căn bản cho người mới bắt đầu', 'Tìm hiểu các nguyên lý cơ bản trong marketing', 50),
    (10, 10, 'Phân tích dữ liệu nâng cao với Python', 'Phân tích dữ liệu với Python và Pandas', 'Hướng dẫn sử dụng Python để phân tích dữ liệu lớn', 60);


INSERT INTO Exercise(Exercise_Order, Lesson_Order, Course_ID, Chapter_Name, Exercise_Title, Exercise_Solution, Exercise_Number_Of_Correct_Answers, Exercise_Content)
VALUES
    (1, 1, 1, 'Giới thiệu Python', 'Bài tập: In ra câu chào', 'Sử dụng lệnh print để in ra câu chào', 1, 'Viết chương trình Python để in ra "Hello, World!"'),
    (2, 2, 2, 'Cơ bản về HTML và CSS', 'Bài tập: Tạo trang web cơ bản', 'Sử dụng HTML và CSS để tạo một trang web cơ bản', 2, 'Tạo một trang HTML với tiêu đề và đoạn văn bản.'),
    (3, 3, 3, 'Kỹ năng thuyết trình hiệu quả', 'Bài tập: Thực hành thuyết trình', 'Luyện tập thuyết trình trước gương và ghi âm lại', 3, 'Thực hiện một bài thuyết trình 5 phút về một chủ đề yêu thích.'),
    (4, 4, 4, 'Cách sử dụng Photoshop cơ bản', 'Bài tập: Chỉnh sửa ảnh cơ bản', 'Sử dụng công cụ cắt và thay đổi kích thước ảnh', 4, 'Chỉnh sửa một bức ảnh để cắt bỏ phần không cần thiết và thay đổi kích thước.'),
    (5, 5, 5, 'Hàm và công thức trong Excel', 'Bài tập: Sử dụng hàm SUM và AVERAGE', 'Tính tổng và trung bình của một dãy số', 5, 'Sử dụng hàm SUM và AVERAGE để tính tổng và trung bình của một cột dữ liệu.'),
    (6, 6, 6, 'Quản lý thời gian trong công việc', 'Bài tập: Lập kế hoạch tuần', 'Lập kế hoạch tuần làm việc hiệu quả', 6, 'Lập một kế hoạch công việc cho tuần tới, bao gồm các công việc và thời gian thực hiện.'),
    (7, 7, 7, 'Java nâng cao: OOP và JavaFX', 'Bài tập: Tạo ứng dụng Java với GUI', 'Lập trình ứng dụng Java với giao diện người dùng', 7, 'Tạo một ứng dụng Java đơn giản với giao diện người dùng sử dụng JavaFX.'),
    (8, 8, 8, 'Giao tiếp tiếng Anh hàng ngày', 'Bài tập: Thực hành giao tiếp', 'Thực hành các câu giao tiếp hàng ngày', 8, 'Thực hành giao tiếp tiếng Anh trong một tình huống cụ thể như gọi món ăn tại nhà hàng.'),
    (9, 9, 9, 'Nguyên lý cơ bản trong Marketing', 'Bài tập: Phân tích chiến dịch marketing', 'Phân tích chiến dịch marketing của một công ty', 9, 'Chọn một chiến dịch marketing nổi bật và phân tích chiến lược của nó.'),
    (10, 10, 10, 'Phân tích dữ liệu nâng cao với Python', 'Bài tập: Phân tích dữ liệu với Pandas', 'Sử dụng Pandas để xử lý và phân tích dữ liệu', 10, 'Tải dữ liệu CSV và sử dụng Pandas để phân tích dữ liệu và tính toán thống kê.');


INSERT INTO Document(Document_ID, Course_ID, Chapter_Name, Document_Author, Document_Title, Document_Size, Document_Type)
VALUES
    (1, 1, 'Giới thiệu Python', 'Nguyễn Văn A', 'Giới thiệu Python cơ bản', 150, 'PDF'),
    (2, 2, 'Cơ bản về HTML và CSS', 'Trần Thị B', 'Tạo trang web với HTML và CSS', 200, 'PDF'),
    (3, 3, 'Kỹ năng thuyết trình hiệu quả', 'Lê Văn C', 'Hướng dẫn thuyết trình hiệu quả', 180, 'PDF'),
    (4, 4, 'Cách sử dụng Photoshop cơ bản', 'Phạm Thị D', 'Hướng dẫn Photoshop cơ bản', 250, 'PDF'),
    (5, 5, 'Hàm và công thức trong Excel', 'Đỗ Thanh E', 'Excel nâng cao: Hàm và công thức', 300, 'PDF'),
    (6, 6, 'Quản lý thời gian trong công việc', 'Hoàng Văn F', 'Quản lý thời gian hiệu quả', 100, 'PDF'),
    (7, 7, 'Java nâng cao: OOP và JavaFX', 'Ngô Thị G', 'Java nâng cao với OOP', 220, 'PDF'),
    (8, 8, 'Giao tiếp tiếng Anh hàng ngày', 'Bùi Văn H', 'Tiếng Anh giao tiếp cơ bản', 150, 'PDF'),
    (9, 9, 'Nguyên lý cơ bản trong Marketing', 'Phan Thị I', 'Marketing căn bản cho người mới', 250, 'PDF'),
    (10, 10, 'Phân tích dữ liệu nâng cao với Python', 'Vũ Minh J', 'Phân tích dữ liệu với Python và Pandas', 300, 'PDF');


INSERT INTO Test(Test_Order, Chapter_Name, Course_ID, Test_Number_Of_Questions, Test_Solution, Test_TakenTimes, Test_Number_Of_Correct_Answers, Test_Content)
VALUES
    (1, 'Giới thiệu Python', 1, 10, 'Solution 1', 5, 8, 'Câu hỏi kiểm tra kiến thức cơ bản về Python.'),
    (2, 'Cơ bản về HTML và CSS', 2, 20, 'Solution 2', 10, 15, 'Câu hỏi kiểm tra khả năng tạo trang web cơ bản với HTML và CSS.'),
    (3, 'Kỹ năng thuyết trình hiệu quả', 3, 15, 'Solution 3', 8, 12, 'Câu hỏi kiểm tra khả năng thuyết trình hiệu quả và các phương pháp thuyết trình.'),
    (4, 'Cách sử dụng Photoshop cơ bản', 4, 10, 'Solution 4', 7, 9, 'Câu hỏi kiểm tra kiến thức cơ bản về Photoshop và công cụ chỉnh sửa ảnh.'),
    (5, 'Hàm và công thức trong Excel', 5, 12, 'Solution 5', 6, 10, 'Câu hỏi kiểm tra khả năng sử dụng công thức trong Excel.'),
    (6, 'Quản lý thời gian trong công việc', 6, 8, 'Solution 6', 5, 6, 'Câu hỏi kiểm tra các phương pháp quản lý thời gian hiệu quả.'),
    (7, 'Java nâng cao: OOP và JavaFX', 7, 20, 'Solution 7', 9, 16, 'Câu hỏi kiểm tra kiến thức OOP và JavaFX trong lập trình Java.'),
    (8, 'Giao tiếp tiếng Anh hàng ngày', 8, 10, 'Solution 8', 4, 8, 'Câu hỏi kiểm tra khả năng giao tiếp tiếng Anh hàng ngày.'),
    (9, 'Nguyên lý cơ bản trong Marketing', 9, 15, 'Solution 9', 6, 12, 'Câu hỏi kiểm tra các nguyên lý cơ bản trong marketing.'),
    (10, 'Phân tích dữ liệu nâng cao với Python', 10, 20, 'Solution 10', 10, 18, 'Câu hỏi kiểm tra khả năng phân tích dữ liệu với Python và Pandas.');






----------------------------------FUNCTION - TRIGGER - PROCEDURE----------------------------------


-- Thủ tục
--a. Insert: InsertCourse - Thêm một khóa học mới vào bảng Course
GO
CREATE PROCEDURE InsertCourse(
    @p_Course_ID INT,
    @p_Course_Name VARCHAR(255),
    @p_Course_Status VARCHAR(255),
    @p_Course_Description TEXT,
    @p_Course_Price INT,
    @p_Course_Image TEXT,
    @p_Course_Start_Date DATE,
    @p_Course_End_Date DATE,
    @p_Course_Categories_ID INT
)
AS
BEGIN
    -- Kiểm tra xem danh mục có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Categories
        WHERE Categories_ID = @p_Course_Categories_ID
    )
    BEGIN
        RAISERROR('Danh mục không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Thêm dữ liệu vào bảng Course
    INSERT INTO Course(
        Course_ID,
        Course_Name,
        Course_Status,
        Course_Description,
        Course_Price,
        Course_Image,
        Course_Start_Date,
        Course_End_Date,
        Course_Categories_ID
    )
    VALUES (
        @P_Course_ID,
        @p_Course_Name,
        @p_Course_Status,
        @p_Course_Description,
        @p_Course_Price,
        @p_Course_Image,
        @p_Course_Start_Date,
        @p_Course_End_Date,
        @p_Course_Categories_ID
    );

    -- Lấy giá trị Course_ID vừa được tạo
    DECLARE @NewCourseID INT;
    SET @NewCourseID = SCOPE_IDENTITY();

    -- Thông báo thành công
    SELECT CONCAT(@p_Course_ID, 'Khóa học "', @p_Course_Name, '" đã được thêm thành công với Course_ID = ', @NewCourseID, '!');
END;

EXEC InsertCourse 501, 'Lập trình C++ cơ bản', 'Open', 'Khóa học giúp bạn nắm vững các kiến thức cơ bản về C++.', 400, 'c++_basic.jpg', '2024-01-01', '2024-06-30', 1;


--b. Update: UpdateCourse - Cập nhật thông tin của một khóa học
GO
CREATE PROCEDURE UpdateCourse(
    @p_Course_ID INT,
    @p_Course_Name VARCHAR(255),
    @p_Course_Status VARCHAR(255),
    @p_Course_Description TEXT,
    @p_Course_Price INT,
    @p_Course_Image TEXT,
    @p_Course_Start_Date DATE,
    @p_Course_End_Date DATE,
    @p_Course_Categories_ID INT
)

AS

BEGIN
    -- Kiểm tra xem khóa học có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Course
        WHERE Course_ID = @p_Course_ID
    )
    BEGIN
        RAISERROR('Khóa học không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem danh mục có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Categories
        WHERE Categories_ID = @p_Course_Categories_ID
    )
    BEGIN
        RAISERROR('Danh mục không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Cập nhật thông tin khóa học
    UPDATE Course
    SET
        Course_Name = @p_Course_Name,
        Course_Status = @p_Course_Status,
        Course_Description = @p_Course_Description,
        Course_Price = @p_Course_Price,
        Course_Image = @p_Course_Image,
        Course_Start_Date = @p_Course_Start_Date,
        Course_End_Date = @p_Course_End_Date,
        Course_Categories_ID = @p_Course_Categories_ID
    WHERE Course_ID = @p_Course_ID;

    -- Thông báo thành công
    SELECT CONCAT('Khóa học "', @p_Course_Name, '" đã được cập nhật thành công!');
END;


EXEC UpdateCourse 501, 'Lập trình C++ cơ bản', 'Open', 'Khóa học giúp bạn nắm vững các kiến thức cơ bản về C++.', 500, 'c++_basic.jpg', '2024-01-01', '2024-06-30', 1;



--c. Delete: DeleteCourse - Xóa một khóa học khỏi bảng Course

GO
CREATE PROCEDURE DeleteCourse(
    @p_Course_ID INT
)
AS

BEGIN
    -- Kiểm tra xem khóa học có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Course
        WHERE Course_ID = @p_Course_ID
    )
    BEGIN
        RAISERROR('Khóa học không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Xóa khóa học
    DELETE FROM Course
    WHERE Course_ID = @p_Course_ID;

    -- Thông báo thành công
    SELECT CONCAT('Khóa học có Course_ID = ', @p_Course_ID, ' đã được xóa thành công!');
END;

EXEC DeleteCourse 501;





--Trigger

-- Trigger 1: Kiểm tra thời gian bắt đầu và kết thúc của khóa học

GO
CREATE TRIGGER tr_CheckCourseDates
ON Course
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra xem thời gian bắt đầu và kết thúc hợp lệ hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE  Course_Start_Date >= Course_End_Date)
    BEGIN
        RAISERROR('Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc của khóa học.', 16, 1);
        RETURN;
    END;

    -- Thêm dữ liệu mới vào bảng Course nếu hợp lệ
    INSERT INTO Course (Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID)
    SELECT Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID
    FROM inserted;

    -- Thông báo thành công
    SELECT 'Khóa học đã được thêm thành công!';
END;
GO


-- Trigger 2: Kiểm tra giá trị giảm giá khi thêm phiếu giảm giá mới
CREATE TRIGGER tr_CheckCouponValue
ON Coupon
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra xem giá trị giảm giá có hợp lệ (không âm) hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Value < 0)
    BEGIN
        RAISERROR('Giá trị giảm giá phải là số không âm.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem loại giảm giá có hợp lệ hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Type NOT IN ('Percent', 'Fixed'))
    BEGIN
        RAISERROR('Loại giảm giá phải là "Percent" hoặc "Fixed".', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem ngày bắt đầu có nhỏ hơn ngày kết thúc hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Start_Date >= Coupon_Expiry_Date)
    BEGIN
        RAISERROR('Ngày bắt đầu phải nhỏ hơn ngày kết thúc.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem giá trị giảm giá tối đa có hợp lệ (không âm) hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Max_Discount < 0)
    BEGIN
        RAISERROR('Giá trị giảm giá tối đa phải là số không âm.', 16, 1);
        RETURN;
    END;

    -- Thêm phiếu giảm giá mới vào bảng Coupon nếu hợp lệ
    INSERT INTO Coupon (Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount)
    SELECT Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount
    FROM inserted;

    -- Thông báo thành công
    SELECT 'Phiếu giảm giá đã được thêm thành công!';
END;
GO




-- Thủ tục

-- Hàm