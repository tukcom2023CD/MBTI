# 폴더 구조

-root
	-domain
		-product
			-controller
				-ProductController.java
			-service
				-ProductService.java
			-repository
				-ProductRepository.java
			-dto
				-request
				-response
			-entity
			-exception

# 호출 순서

ProductController -> ProductService     -> ProductRepository        -> Product
(findProductById) -> (findProductByPID) -> (findProductByProductId)